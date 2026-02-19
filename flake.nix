{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
    let
      configuration = { pkgs, ... }: {
        # services.nix-daemon.enable = true;
        # Necessary for using flakes on this system.
        nix.settings.experimental-features = "nix-command flakes";

        system.configurationRevision = self.rev or self.dirtyRev or null;

        system.defaults = {
          NSGlobalDomain."com.apple.swipescrolldirection" = false;
          dock.autohide = true;
          finder = {
            AppleShowAllExtensions = true;
            AppleShowAllFiles = true;
          };
        };

        system.keyboard = {
          enableKeyMapping = true;
          remapCapsLockToEscape = true;
        };

        # Used for backwards compatibility. please read the changelog
        # before changing: `darwin-rebuild changelog`.
        system.stateVersion = 4;

        # The platform the configuration will be used on.
        # If you're on an Intel system, replace with "x86_64-darwin"
        nixpkgs.hostPlatform = "aarch64-darwin";

        # Declare the user that will be running `nix-darwin`.
        users.users."john.li" = {
          name = "john.li";
          home = "/Users/john.li";
        };

        ids.gids.nixbld = 350;

        # security.pam.enableSudoTouchIdAuth = true;
        security.pam.services.sudo_local.touchIdAuth = true;

        # Create /etc/zshrc that loads the nix-darwin environment.
        programs.zsh.enable = true;
        # programs.bash.enable = true;

        environment.systemPackages = with pkgs; [
          neofetch
          coreutils
          inetutils
          ripgrep
          tree
          gotools
          revive
          kubelogin
          redocly
          jdk
          graphviz
          dbeaver-bin
          pdfgrep
          python3
          xmlstarlet
          nushell
          gopls
          sketchybar
          # rustc
          # rust-analyzer
          # rustfmt
          rustup
          exiftool
          mdformat
          lazygit
          dotnet-sdk
          entr
          delve
          fd
          sleek
          xan
          wget
        ];

        homebrew = {
          enable = true;
          onActivation.cleanup = "uninstall";

          taps = [
            "nikitabobko/tap"
            "schpet/tap"
          ];
          brews = [
            "go"
            "cowsay"
            "mysql"
            "mysql-client"
            "azure-cli"
            "pam-reattach"
            "spaceship"
            "goose"
            "nvm"
            "sqlc"
            "golangci-lint"
            "mas"
            "stylua"
            "gnu-sed"
            "dcmtk"
            "gofumpt"
            "golines"
            "nx"
            "virtualenv"
            "tcl-tk"
            "cmake"
            "oterm"
            "glab"
            "gh"
            "yq"
            "schpet/tap/linear"
            "gopass"
            # "artginzburg/tap/sudo-touchid"
          ];
          casks = [
            # "brave-browser" ## need to remove existing first
            "alacritty"
            "nikitabobko/tap/aerospace"
            "obsidian"
            "raycast"
            "orbstack"
            "karabiner-elements"
            "font-hack-nerd-font"
            "postman"
            "codex"
          ];
          # masApps = {
          #   "Flow - Focus & Pomodoro Timer" = 1423210932;
          # };
        };
      };
    in
    {
      darwinConfigurations."Johns-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        # darwinConfigurations."Johns-Mac" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.verbose = true;
            home-manager.users."john.li" = {
              imports = [
                ./home/common.nix
                ./home/darwin.nix
              ];
            };
          }
        ];
      };

      # Add new Linux profiles by creating home/linux-<name>.nix and wiring it here.
      # Example:
      # homeConfigurations."ubuntu@laptop" = home-manager.lib.homeManagerConfiguration {
      #   pkgs = import nixpkgs { system = "x86_64-linux"; };
      #   modules = [ ./home/common.nix ./home/linux-laptop.nix ];
      # };
      homeConfigurations."ubuntu@dev" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { system = "x86_64-linux"; };
        modules = [
          ./home/common.nix
          ./home/linux-dev.nix
        ];
      };
    };
}
