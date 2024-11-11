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
    configuration = {pkgs, ... }: {

      services.nix-daemon.enable = true;
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
      users.users."john.li"= {
        name = "john.li";
        home = "/Users/john.li";
      };

      security.pam.enableSudoTouchIdAuth = true;

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
        dcmtk
        jdk
        graphviz
        dbeaver-bin
        pdfgrep
        python3
        xmlstarlet
      ];

      homebrew = {
        enable = true;
        onActivation.cleanup = "uninstall";

        taps = [
          "nikitabobko/tap"
        ];
        brews = [
          "golang"
          "cowsay"
          "mysql"
          "mysql-client"
          "azure-cli"
          "pam-reattach"
          "spaceship"
          "goose"
          "nvm"
          "openapi-generator"
          "sqlc"
          "golangci-lint"
          "mas"
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
        ];
        masApps = {
          "Flow - Focus & Pomodoro Timer" = 1423210932;
        };
      };
    };
  homeconfig = {config, pkgs, lib, ...}:
    let
    tmux-fzf-session-switch = pkgs.tmuxPlugins.mkTmuxPlugin
    {
      pluginName = "tmux-fzf-session-switch";
      rtpFilePath = "main.tmux";
      version = "unstable-2023-01-06";
      src = pkgs.fetchFromGitHub {
        owner = "brokenricefilms";
        repo = "tmux-fzf-session-switch";
        rev = "28fc98cc92914c9cde1ac0d0dcb1a5cfebde2925";
        sha256 = "sha256-RcCwDLMOXrijt+j6C4fqFA9gBpO6YJmK1yNclGa3jgw=";
      };
    };
  in
  {
# this is internal compatibility configuration
# for home-manager, don't change this!
    home.stateVersion = "23.05";
# Let home-manager install and manage itself.
    programs.home-manager.enable = true;

    home.shellAliases = {
      ga="git add";
      gaa="git add -A";
      gb="git branch --sort=-committerdate";
      gc="git commit";
      gs="git status";
      gf="git fetch --all";
      gd="git diff";
      gpl="git pull";
      gps="git push";
      gfps="git push -u origin `git rev-parse --abbrev-ref HEAD`";
      grhh="git reset HEAD --hard";
      gco="git checkout";
      gl="git log --oneline --decorate --graph --abbrev-commit --date=relative'";
      glt="git describe --tags --abbrev=0 master";
      l="ls -latrh --color=auto";
      ls="ls --color=auto";
      grep="grep --color=auto";
      ta="tmux a -t";
      tls="tmux ls";
      getazkey="AZKEY=$(az account get-access-token --resource-type oss-rdbms --output tsv --query accessToken | tee >(pbcopy))";
    };

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      defaultKeymap = "viins";
      initExtra = ''
        tns() {
          cd $1
          toplevel=$(git rev-parse --show-toplevel)
          basename=$(basename $toplevel)
          tmux new -s $basename
        }
        source $(brew --prefix)/opt/spaceship/spaceship.zsh
           export NVM_DIR="$HOME/.nvm"
    [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" # This loads nvm
    [ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion
      '';
      envExtra = ''
        SPACESHIP_AZURE_SHOW=false
        SPACESHIP_DOCKER_SHOW=false
        SPACESHIP_GOLANG_SHOW=false
      '';

      # autoload -Uz vcs_info # enable vcs_info
      # precmd () { vcs_info } # always load before displaying the prompt
      # zstyle ':vcs_info:*' formats ' %s(%F{red}%b%f)' # git(main)
      #
      # PS1='%n@%m %F{red}%/%f$vcs_info_msg_0_ $ ' # david@macbook /tmp/repo (main) $
      #   '';
    };

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.git = {
      enable = true;
      extraConfig = {
        url = {
          "ssh://git@gitlab.com/" = {
            insteadOf = "https://gitlab.com/";
          };
        };
        user = {
          email = "john.li@pocket.health";
          name = "John Li";
        };
      };
    };

    programs.tmux = {
      enable = true;
      shortcut = "a";
      terminal = "screen-256color";
      mouse = true;
      baseIndex = 1;
      historyLimit = 5000;
      keyMode = "vi";

# customPaneNavigationAndResize = true;

      plugins = with pkgs.tmuxPlugins; [
        cpu
          tmux-fzf
          {
            plugin = tmux-fzf-session-switch;
          }
          {
            plugin = dracula;
            extraConfig = ''
              set -g @dracula-show-battery false
              set -g @dracula-show-powerline true
              set -g @dracula-refresh-rate 10
              '';
          }
# {
#   plugin = tmuxPlugins.resurrect;
#   extraConfig = "set -g @resurrect-strategy-nvim 'session'";
# }
# {
#   plugin = tmuxPlugins.continuum;
#   extraConfig = ''
#   set -g @continuum-restore 'on'
#   set -g @continuum-save-interval '60' # minutes
#   '';
# }
      ];
      extraConfig = ''
        set-option -g allow-rename off
        set-option -g focus-events on

        set -g window-style 'fg=colour247,bg=colour236'
        set -g window-active-style 'fg=default,bg=colour234'
        set -g pane-border-style default
        set -g pane-active-border-style fg=colour27

        bind R source-file ~/.config/tmux/tmux.conf \; display-message "Tmux config file reloaded."

        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}" -p 22

        is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?\.?(view|n?vim?x?)(-wrapped)?(diff)?$'"

        bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h' 'select-pane -L'
        bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j' 'select-pane -D'
        bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k' 'select-pane -U'
        bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l' 'select-pane -R'

        bind-key -T copy-mode-vi 'C-h' select-pane -L
        bind-key -T copy-mode-vi 'C-j' select-pane -D
        bind-key -T copy-mode-vi 'C-k' select-pane -U
        bind-key -T copy-mode-vi 'C-l' select-pane -R
        '';
    };


    programs.neovim = {
      enable = true;
      vimAlias = true;
    vimdiffAlias = true;
    };

# programs.alacritty = {
#   enable = true;
#   settings = {
#     window = {
#       decorations = "full";
#       startup_mode = "Windowed";
#     };
#     font = {
#       size = 20.0;
#       normal = {
#         family = "Hack Nerd Font";
#         style = "Regular";
#       };
#       bold = {
#         family = "Hack Nerd Font";
#         style = "Bold";
#       };
#       Italic = {
#         family = "Hack Nerd Font";
#         style = "Italic";
#       };
#     };
#   };
# };

    home.packages = with pkgs; [
    ];

    home.sessionVariables = {
      EDITOR = "nvim";
    };

    home.file = {
      ".vimrc".source = ./vimrc;
      ".aerospace.toml".source = ./aerospace.toml;
      ".alacritty.toml".source = ./alacritty.toml;
      ".config/karabiner/karabiner.json".source = ./karabiner.json;
      ".config/nvim" = {
        source = ./nvim;
        recursive = true;
      };
      # ".config/nvim/init.lua".source = ./nvim/init.lua;
      # ".config/nvim/lua/chadrc.lua".source = ./nvim/lua/chadrc.lua;
    };

    # xdg.confgFile."nvim" = {
    #   source = ./nvim;
    #   recursive = true;
    # };
};
in
{
  darwinConfigurations."Johns-MacBook-Pro" = nix-darwin.lib.darwinSystem {
    modules = [
      configuration
        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.verbose = true;
          home-manager.users."john.li" = homeconfig;
        }
    ];
  };
};
}
