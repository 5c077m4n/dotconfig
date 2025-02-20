{
  pkgs,
  pkgs-unstable,
  username,
  ...
}:
let
  stateVersion = "24.11";
in
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";

    users.${username} =
      { config, ... }:
      {
        home =
          let
            inherit (pkgs) lib stdenv;
          in
          {
            inherit stateVersion;

            packages =
              [
                # General
                pkgs-unstable.neovim
                pkgs.tmux
                pkgs.htop
                pkgs.curl
                pkgs.wget
                pkgs.coreutils
                pkgs.jq
                pkgs.yq
                pkgs.openssh
                pkgs.less
                pkgs.busybox
                pkgs.gnumake
                pkgs.gcc
                pkgs.gnupg
                pkgs.stow
                # VCS
                ## Git
                pkgs.git
                pkgs.hub
                pkgs.lazygit
                pkgs.delta
                pkgs.git-absorb
                # TUI
                pkgs.starship
                pkgs.lf
                pkgs.eza
                pkgs.bat
                pkgs.procs
                # Search
                pkgs.fd
                pkgs.fzf
                pkgs.ripgrep
                # LLMs
                pkgs.ollama
                # Shells
                ## Bash
                pkgs.bash
                ## ZSH
                pkgs.zsh
                ## Fish
                pkgs.fish
                pkgs.fishPlugins.fzf-fish
                pkgs.fishPlugins.autopair
                ## Misc
                ### Formatters
                pkgs.beautysh
                pkgs.shfmt
                pkgs.shellharden
                # JavaScript
                pkgs-unstable.nodejs_22
                pkgs-unstable.eslint_d
                pkgs-unstable.prettierd
                pkgs-unstable.pnpm
                pkgs-unstable.yarn-berry # `yarn` >=4.5
                pkgs-unstable.deno
                # Python
                pkgs-unstable.python310
                pkgs-unstable.pyenv
                pkgs-unstable.poetry
                pkgs-unstable.mypy
                pkgs-unstable.pylint
                pkgs-unstable.black
                pkgs-unstable.isort
                # Golang
                pkgs-unstable.go
                pkgs-unstable.air # Live reloader
                pkgs-unstable.tinygo
                pkgs-unstable.golangci-lint
                # Rust
                pkgs-unstable.rustup
                pkgs-unstable.cargo-insta # Snapshot testing
                pkgs-unstable.pkg-config
                pkgs-unstable.openssl
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
                pkgs-unstable.wasmtime
                # Gleam
                pkgs-unstable.gleam
                pkgs-unstable.erlang
                # YAML
                pkgs.yamllint
                # Markdown
                pkgs.marksman
                # K8s
                pkgs-unstable.kubectx
                pkgs-unstable.k9s
                # Containers
                ## Podman
                pkgs-unstable.podman
                pkgs-unstable.podman-compose
                # DBs
                ## TUIs
                pkgs.pgcli
                pkgs.mycli
                ## SQL
                ### Formatters
                pkgs.sqlfluff
                # Fonts
                (pkgs.nerdfonts.override {
                  fonts = [
                    "FiraMono"
                    "Hack"
                  ];
                })
                # Cloud
                pkgs.awscli2
                # Misc
                pkgs.gopass
                pkgs.android-tools # ADB
              ]
              ++ lib.optionals stdenv.isLinux [
                # CLI utils
                ## Clipboard
                pkgs.xclip
                ## Audio control
                pkgs.pulseaudio
                ## Screen brightness control
                pkgs.brightnessctl
                ## Battery data
                pkgs.acpi
                # GUIs
                pkgs.firefox
                pkgs.google-chrome
                pkgs.kitty
                pkgs.copyq
                pkgs.feh # Image viewer
                pkgs.inkscape # Image editor
                pkgs-unstable.pgadmin4-desktopmode # PostgreSQL viewer
                pkgs.libreoffice
              ]
              ++ lib.optionals stdenv.isDarwin [
                # Bluetooth
                pkgs.blueutil
              ];
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

          tmux =
            let
              shell = "${pkgs.fish}/bin/fish";
            in
            {
              enable = true;
              clock24 = true;
              inherit shell;

              plugins =
                let
                  inherit (pkgs) tmuxPlugins fetchFromGitHub;
                  tmux-nvim = tmuxPlugins.mkTmuxPlugin {
                    pluginName = "tmux.nvim";
                    version = "unstable-2024-12-01";
                    src = fetchFromGitHub {
                      owner = "aserowy";
                      repo = "tmux.nvim";
                      rev = "b646e89907a84bf40c9bda3de6fbcab2edd6e393";
                      sha256 = "sha256-28JOlTOBjwlOnu2/L1w5AIaW21Q3c3Ah0ZqPuz02s4o=";
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
                        set -ogq @catppuccin_window_text "#W ${zoomIconQuery}"
                        set -ogq @catppuccin_window_default_text "#W ${zoomIconQuery}" # deprecated(?)
                        set -ogq @catppuccin_window_current_text "#W ${zoomIconQuery}"
                      '';
                  }
                  {
                    plugin = tmuxPlugins.resurrect;
                    extraConfig = ''
                      set -g @resurrect-strategy-vim "session"
                      set -g @resurrect-strategy-nvim "session"
                      set -g @resurrect-capture-pane-contents "on"
                    '';
                  }
                  {
                    # Must be the last plugin to be cofigured https://github.com/tmux-plugins/tmux-continuum#known-issues
                    plugin = tmuxPlugins.continuum;
                    extraConfig = ''
                      set -g @continuum-restore "on"
                      set -g @continuum-boot "on"
                      set -g @continuum-save-interval "10"
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

                  set-option -g default-command "${shell}" # Fix for Fish not being the default shell

                  # Refresh config file
                  unbind-key r
                  bind-key r source-file "${tmuxConfPath}"\; display "Refreshed config file @ ${tmuxConfPath}"
                '';
            };
        };
      };
  };
}
