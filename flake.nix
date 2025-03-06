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
      users.users."john.li"= {
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
      ];

      homebrew = {
        enable = true;
        onActivation.cleanup = "uninstall";

        taps = [
          "nikitabobko/tap"
          # "artginzburg/tap"
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
          "openapi-generator"
          "sqlc"
          "golangci-lint"
          "mas"
          "stylua"
          "gnu-sed"
          "dcmtk"
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
        ];
        masApps = {
          "Flow - Focus & Pomodoro Timer" = 1423210932;
        };
      };
    };
  homeconfig = {config, pkgs, lib, ...}:
    let
    # add this to plugin def first, run darwin switch, and then copy real sha
    # sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
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
    floax =
    pkgs.tmuxPlugins.mkTmuxPlugin
    {
      # Note pluginName MUST be "floax"
      pluginName = "floax";
      version = "unstable-2024-31-08";
      src = pkgs.fetchFromGitHub {
        owner = "omerxx";
        repo = "tmux-floax";
        rev = "dab0587c5994f3b061a597ac6d63a5c9964d2883";
        sha256 = "sha256-gp/l3SLmRHOwNV3glaMsEUEejdeMHW0CXmER4cRhYD4=";
      };
    };
    # floax = pkgs.tmuxPlugins.mkTmuxPlugin
    # {
    #   pluginName = "floax";
    #   # rtpFilePath = "main.tmux";
    #   version = "unstable-2024-31-08";
    #   src = pkgs.fetchFromGitHub {
    #     owner = "omerxx";
    #     repo = "tmux-floax";
    #     rev = "61c7f466b9a4ceed56f99d403250164170d586cd";
    #     sha256 = "sha256-DOwn7XEg/L95YieUAyZU0FJ49vm2xKGUclm8WCKDizU=";
    #   };
    # };
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
      lg="lazygit";
      # l="eza -larh --color=always --icons";
      # ls="eza --color=always --icons";
      # tree="eza --tree --color=always --icons";
      y="yazi";
      v="nvim";
      grep="grep --color=auto";
      ta="tmux a -t";
      tls="tmux ls";
      cat="bat --style=plain";
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
        bindkey -v '^?' backward-delete-char
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

      plugins = 
        [
          # # Not available in pkgs.tmuxPlugins
          # {
          #   plugin = floax;
          #   extraConfig = ''
          #     set -g @floax-bind 'p'
          #     set -g @floax-border-80color 'blue'
          #     set -g @floax-width '50%'
          #     set -g @floax-height '50%'
          #   '';
          # }
        ]
        ++ (with pkgs.tmuxPlugins; [
        cpu
        tmux-fzf
        {
          plugin = session-wizard;
          extraConfig = ''
            set -g @session-wizard 'f'
          '';
        }
        # {
        #   plugin = tmux-fzf-session-switch;
        # }
        {
          plugin = dracula;
          extraConfig = ''
            set -g @dracula-show-powerline true
            set -g @dracula-refresh-rate 10
            set -g @dracula-show-battery false
            set -g @dracula-show-empty-plugins false
            set -g @dracula-show-fahrenheit false
            set -g @dracula-show-left-icon session
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
      ]);
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

        # navigation with aserowy/tmux.nvim
        is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?\.?(view|n?vim?x?)(-wrapped)?(diff)?$'"

        bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h' 'select-pane -L'
        bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j' 'select-pane -D'
        bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k' 'select-pane -U'
        bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l' 'select-pane -R'

        bind-key -T copy-mode-vi 'C-h' select-pane -L
        bind-key -T copy-mode-vi 'C-j' select-pane -D
        bind-key -T copy-mode-vi 'C-k' select-pane -U
        bind-key -T copy-mode-vi 'C-l' select-pane -R

        # resize with aserowy/tmux.nvim
        # is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
        #
        # bind -n 'M-h' if-shell "$is_vim" 'send-keys M-h' 'resize-pane -L 1'
        # bind -n 'M-j' if-shell "$is_vim" 'send-keys M-j' 'resize-pane -D 1'
        # bind -n 'M-k' if-shell "$is_vim" 'send-keys M-k' 'resize-pane -U 1'
        # bind -n 'M-l' if-shell "$is_vim" 'send-keys M-l' 'resize-pane -R 1'
        #
        # bind-key -T copy-mode-vi M-h resize-pane -L 1
        # bind-key -T copy-mode-vi M-j resize-pane -D 1
        # bind-key -T copy-mode-vi M-k resize-pane -U 1
        # bind-key -T copy-mode-vi M-l resize-pane -R 1

        # bind-key -n 'C-\' run-shell -b "$HOME/.local/bin/tmux-toggle-term.sh float"

        # Don't let tmux wait for escape / Meta commands - https://github.com/tmux/tmux/issues/131#issuecomment-145853211
        # https://neovim.io/doc/user/faq.html#faq - ESC IN TMUX OR GNU SCREEN IS DELAYED
        set -sg escape-time 0

        bind-key C-h resize-pane -L 5
        bind-key C-j resize-pane -D 5
        bind-key C-k resize-pane -U 5
        bind-key C-l resize-pane -R 5
        '';
    };


    programs.neovim = {
      enable = true;
      vimAlias = true;
      vimdiffAlias = true;
    };

    programs.zellij = {
      enable = true;
    };
    
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    # programs.eza = {
    #   enable = true;
    #   enableZshIntegration = true;
    # };

    programs.wezterm = {
      enable = true;
      enableZshIntegration = true;
      extraConfig = ''
      local wezterm = require 'wezterm'
      local config = wezterm.config_builder()
      config.front_end = "WebGpu"
      config.hide_tab_bar_if_only_one_tab = true
      config.color_scheme = 'Dracula'
      config.font = wezterm.font 'Hack Nerd Font'
      config.font_size = 14.0
      return config
      '';
    };

    programs.yazi = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.bat = {
      enable = true;
      themes = {
        dracula = {
          src = pkgs.fetchFromGitHub {
            owner = "dracula";
            repo = "sublime"; # Bat uses sublime syntax for its themes
              rev = "26c57ec282abcaa76e57e055f38432bd827ac34e";
            sha256 = "019hfl4zbn4vm4154hh3bwk6hm7bdxbr1hdww83nabxwjn99ndhv";
          };
          file = "Dracula.tmTheme";
        };
      };
    };
    
    # programs.atuin = {
    #   enable = true;
    #   enableZshIntegration = true;
    #   settings = {
    #     style = "compact";
    #   };
    #   flags = [
    #     "--disable-up-arrow"
    #   ];
    # };

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
      ".config/zellij/config.kdl".source = ./zellij-config.kdl;
      ".config/zellij/layouts/simple.kdl".source = ./zellij-simple-layout.kdl;
      ".config/sketchybar/sketchybarrc".source = ./sketchybarrc;
      ".local/bin/tmux-toggle-term".source = ./tmux-toggle-term.sh;
      # TODO: need sketchbar plugins for it to work
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
