{
  pkgs,
  pkgs-unstable,
  username,
  hostPlatform,
  ...
}:
let
  stateVersion = "24.11";

  inherit (pkgs) lib;
  pkgs-master = import pkgs-unstable {
    system = hostPlatform;
    config = {
      allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
          "arc-browser"
        ];
    };
  };
in
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";

    users.${username} =
      { lib, config, ... }:
      {
        home = {
          inherit stateVersion;

          activation =
            let
              inherit (lib.hm.dag) entryAfter;
              inherit (config.home) homeDirectory;
              inherit (pkgs) rsync;
            in
            {
              rsync-home-manager-applications = entryAfter [ "writeBoundary" ] ''
                apps_source="$genProfilePath/home-path/Applications"
                moniker="Home Manager Trampolines"
                app_target_base="${homeDirectory}/Applications"
                app_target="$app_target_base/$moniker"
                mkdir -p "$app_target"
                ${rsync}/bin/rsync --archive --checksum --chmod=-w --copy-unsafe-links --delete "$apps_source/" "$app_target"
              '';
            };

          packages = [
            # General
            pkgs-master.neovim
            pkgs.tmux
            pkgs.htop
            pkgs.curl
            pkgs.wget
            pkgs.coreutils
            pkgs.jq
            pkgs.yq
            pkgs.openssh
            # VCS
            pkgs.git
            pkgs.hub
            pkgs.lazygit
            pkgs.delta
            pkgs.git-absorb
            # TUI
            pkgs.starship
            pkgs.ranger
            pkgs.eza
            pkgs.bat
            # Search
            pkgs.fd
            pkgs.fzf
            pkgs.ripgrep
            # LLMs
            pkgs.ollama
            # Shells
            ## ZSH
            pkgs.zsh
            pkgs.beautysh
            ## Fish
            pkgs.fish
            pkgs.fishPlugins.fzf-fish
            pkgs.fishPlugins.autopair
            # JavaScript
            pkgs.nodejs_22
            pkgs-master.deno
            pkgs-master.eslint_d
            pkgs-master.prettierd
            pkgs-master.pnpm
            pkgs-master.yarn-berry # `yarn` >=4.5
            # Python
            pkgs-master.python313
            pkgs-master.pyenv
            pkgs-master.poetry
            pkgs-master.mypy
            pkgs-master.pylint
            pkgs-master.black
            pkgs-master.isort
            # Golang
            pkgs-master.go
            pkgs-master.air # Live reloader
            pkgs-master.tinygo
            pkgs-master.golangci-lint
            # Rust
            pkgs-master.rustup
            # Zig
            pkgs.zig
            pkgs.zls
            # Lua
            pkgs.luajit
            pkgs.luajitPackages.luacheck
            pkgs.luarocks
            pkgs.stylua
            pkgs.selene
            # Nix
            pkgs.nixfmt-rfc-style
            pkgs.statix
            pkgs.deadnix
            pkgs.nil
            # WASM
            pkgs-master.wasmtime
            # YAML
            pkgs.yamllint
            # K8s
            pkgs-master.kubectx
            pkgs-master.k9s
            # Docker
            pkgs.docker
            pkgs.colima
            pkgs.docker-buildx
            pkgs.docker-compose
            pkgs.lazydocker
            # DBs
            ## TUIs
            pkgs.pgcli
            pkgs.mycli
            # Bluetooth
            pkgs.blueutil
            # Fonts
            (pkgs.nerdfonts.override {
              fonts = [
                "FiraMono"
                "Hack"
              ];
            })
            # Misc
            pkgs.gopass
            pkgs.android-tools # ADB
            # MacOS Applications
            pkgs-master.arc-browser
            pkgs.kitty
            pkgs.iterm2
            pkgs.neovide
            pkgs.vscodium
            pkgs.inkscape
            pkgs.aerospace
            (pkgs.maccy.overrideAttrs (
              let
                version = "2.3.0";
              in
              {
                inherit version;
                src = builtins.fetchurl {
                  url = "https://github.com/p0deje/Maccy/releases/download/${version}/Maccy.app.zip";
                  sha256 = "sha256:17dhaqyrbjl9ck33p64a480zaf7sqd6lrp0da4knagdgffvz9fiy";
                };
              }
            ))
            pkgs.keepassxc
          ];

          file = {
            # Legacy config files
            ".ideavimrc".source = ./home_dotfiles/.ideavimrc;
            ".sleep".source = ./home_dotfiles/.sleep;
            ".wakeup".source = ./home_dotfiles/.wakeup;
            # XDG standard config files
            ".local/bin" = {
              source = ./dotlocal/bin;
              recursive = true;
            };
            ".config" = {
              source = ./dotfiles;
              recursive = true;
            };
          };
        };

        programs = {
          home-manager.enable = true;

          fish = {
            enable = true;

            plugins =
              let
                inherit (pkgs) fishPlugins;
              in
              [
                {
                  name = "fzf-fish";
                  inherit (fishPlugins.fzf-fish) src;
                }
                {
                  name = "autopair";
                  inherit (fishPlugins.autopair) src;
                }
              ];
          };

          tmux = {
            enable = true;
            clock24 = true;
            shell = "${pkgs.fish}/bin/fish";

            plugins =
              let
                inherit (pkgs) tmuxPlugins fetchFromGitHub;
                tmux-nvim = tmuxPlugins.mkTmuxPlugin {
                  pluginName = "tmux.nvim";
                  version = "unstable-2024-12-01";
                  src = fetchFromGitHub {
                    owner = "aserowy";
                    repo = "tmux.nvim";
                    rev = "307bad95a1274f7288aaee09694c25c8cbcd6f1a";
                    sha256 = "sha256-c/1swuJ6pIiaU8+i62Di/1L/b4V9+5WIVzVVSJJ4ls8=";
                  };
                };
              in
              [
                tmuxPlugins.sensible
                {
                  plugin = tmux-nvim;
                  extraConfig = ''
                    set-option -g @tmux-nvim-navigation true
                    set-option -g @tmux-nvim-navigation-cycle true
                    set-option -g @tmux-nvim-navigation-keybinding-left "C-h"
                    set-option -g @tmux-nvim-navigation-keybinding-down "C-j"
                    set-option -g @tmux-nvim-navigation-keybinding-up "C-k"
                    set-option -g @tmux-nvim-navigation-keybinding-right "C-l"
                    set-option -g @tmux-nvim-resize false
                  '';
                }
                {
                  plugin = tmuxPlugins.catppuccin;
                  extraConfig =
                    let
                      flavor = "macchiato"; # `latte`, `frappe`, `macchiato` or `mocha`
                      zoomIconQuery = "#{?window_zoomed_flag,[],}";
                    in
                    ''
                      set -ogq status-right "#{E:@catppuccin_status_application}"
                      set -ag status-right "#{E:@catppuccin_status_session}"

                      set -ogq @catppuccin_flavor "${flavor}"
                      set -ogq @catppuccin_window_status_style "rounded"
                      set -ogq @catppuccin_window_text " #W${zoomIconQuery}"
                      set -ogq @catppuccin_window_default_text " #W${zoomIconQuery}" # deprecated(?)
                      set -ogq @catppuccin_window_current_text " #W${zoomIconQuery}"
                    '';
                }
                {
                  plugin = tmuxPlugins.resurrect;
                  extraConfig = ''
                    set -g @resurrect-strategy-vim 'session'
                    set -g @resurrect-strategy-nvim 'session'
                    set -g @resurrect-capture-pane-contents 'on'
                  '';
                }
                {
                  # Must be the last plugin to be cofigured https://github.com/tmux-plugins/tmux-continuum#known-issues
                  plugin = tmuxPlugins.continuum;
                  extraConfig = ''
                    set -g @continuum-restore 'on'
                    set -g @continuum-boot 'on'
                    set -g @continuum-save-interval '10'
                  '';
                }
              ];
            extraConfig =
              let
                inherit (config.home) homeDirectory;
                inherit (config.xdg) configFile;
                tmuxConfPath = "${homeDirectory}/${configFile."tmux/tmux.conf".target}";
              in
              ''
                unbind-key C-b
                set-option -g prefix C-a # Change prefix command
                bind-key C-a send-prefix

                set-option -g mouse off # Disable mouse
                set-option -g detach-on-destroy off # Switch to another active session instead of quitting

                set-option -g base-index 1 # Fix window numbering
                set-window-option -g pane-base-index 1
                set-option -g renumber-windows on

                # Add more space for the status's bar
                set-option -g status-left-length 100
                set-option -g status-right-length 100
                set-option -g status-left ""
                # Add support for nvim/vim focus events
                set-option -g focus-events on
                # Resize fix
                set-window-option -g aggressive-resize on

                set-window-option -g mode-keys vi

                # Bell notification on process event
                set-window-option -g visual-bell both
                set-window-option -g bell-action other

                # Remove delay for exiting insert mode with ESC in Neovim
                set-option -sg escape-time 10

                # Pane split commands
                unbind-key %
                bind-key '\' split-window -h -l 40% -c "#{pane_current_path}"
                unbind-key '"'
                bind-key - split-window -v -l 40% -c "#{pane_current_path}"

                # Pane resize
                bind-key -r j resize-pane -D 10
                bind-key -r k resize-pane -U 10
                bind-key -r l resize-pane -R 10
                bind-key -r h resize-pane -L 10

                unbind-key Enter
                bind-key Enter resize-pane -Z # Toggle pane full-screen

                bind-key -n M-k send-keys -R \; send-keys C-l \; clear-history # Clear pane scroll

                unbind-key c
                unbind-key n
                bind-key n new-window -c "#{pane_current_path}" # Add new window

                unbind-key w
                bind-key w kill-window # Close current window

                unbind-key q
                bind-key q kill-server # Close current server

                unbind-key C-a
                bind-key C-a choose-tree -wZ # Show all windows

                unbind-key Escape
                bind-key -rn "M-[" previous-window
                bind-key -rn "M-]" next-window
                bind-key -rn "M-{" swap-window -t -1\; select-window -t -1
                bind-key -rn "M-}" swap-window -t +1\; select-window -t +1

                bind-key -T copy-mode-vi v send-keys -X begin-selection
                bind-key -T copy-mode-vi V send-keys -X select-line
                bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
                bind-key -T copy-mode-vi y send-keys -X copy-selection

                unbind-key -T copy-mode-vi MouseDragEnd1Pane # don't exit copy mode when dragging with mouse

                set-option -g default-command "$SHELL" # Fix for Fish not being the default shell

                # Refresh config file
                unbind-key r
                bind-key r source-file "${tmuxConfPath}"\; display "Refreshed config file @ ${tmuxConfPath}"
              '';
          };
        };
      };
  };
}
