{ config, pkgs }:
let
  inherit (pkgs) fish tmuxPlugins fetchFromGitHub;
  shell = "${fish}/bin/fish";
in
{
  enable = true;
  clock24 = true;
  inherit shell;

  plugins =
    let
      tmux-nvim = tmuxPlugins.mkTmuxPlugin {
        pluginName = "tmux.nvim";
        version = "unstable-2024-12-01";
        src = fetchFromGitHub {
          owner = "aserowy";
          repo = "tmux.nvim";
          rev = "2c1c3be0ef287073cef963f2aefa31a15c8b9cd8";
          sha256 = "sha256-/XIjqQr9loWVTXZDaZx2bSQgco46z7yam50dCnM5p1U=";
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

          if-shell "uname | grep --ignore-case --quiet darwin" {
            set-option -g @tmux-nvim-condition "ps -o command -t '#{pane_tty}' | grep --extended-regexp --ignore-case --quiet 'n?vim'"
          }
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
            set-option -ogq status-right " #{E:@catppuccin_status_application} "
            set-option -ag status-right " #{E:@catppuccin_status_session} "

            set-option -ogq @catppuccin_flavor "${flavor}"
            set-option -ogq @catppuccin_window_status_style "rounded"
            set-option -ogq @catppuccin_window_text " #W ${zoomIconQuery}"
            set-option -ogq @catppuccin_window_default_text " #W ${zoomIconQuery}" # deprecated(?)
            set-option -ogq @catppuccin_window_current_text " #W ${zoomIconQuery}"
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

      # MacOS clipboard integration
      if-shell "uname | grep --ignore-case --quiet darwin" {
        bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy"
      }
    '';
}
