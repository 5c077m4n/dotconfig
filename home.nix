{
  pkgs,
  pkgs-unstable,
  username,
  ...
}:
let
  stateVersion = "24.05";
in
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";

    users.${username} = {
      home = {
        inherit stateVersion;

        packages = [
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
          pkgs-unstable.deno
          pkgs-unstable.eslint_d
          pkgs-unstable.prettierd
          pkgs-unstable.pnpm
          pkgs-unstable.yarn-berry # `yarn` >=4.5
          # Python
          pkgs-unstable.python313
          pkgs-unstable.pyenv
          pkgs-unstable.poetry
          pkgs-unstable.mypy
          pkgs-unstable.pylint
          pkgs-unstable.black
          pkgs-unstable.isort
          # Golang
          pkgs-unstable.go
          pkgs-unstable.golangci-lint
          # Rust
          pkgs-unstable.rustup
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
          # K8s
          pkgs-unstable.kubectx
          pkgs-unstable.k9s
          # Docker
          pkgs-unstable.docker_27
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

          plugins = [
            {
              name = "fzf-fish";
              inherit (pkgs.fishPlugins.fzf-fish) src;
            }
            {
              name = "autopair";
              inherit (pkgs.fishPlugins.autopair) src;
            }
          ];
        };

        tmux = {
          enable = true;

          plugins =
            let
              inherit (pkgs) tmuxPlugins fetchFromGitHub;
            in
            [
              tmuxPlugins.sensible
              tmuxPlugins.resurrect
              tmuxPlugins.catppuccin
              (tmuxPlugins.mkTmuxPlugin {
                pluginName = "tmux.nvim";
                version = "master";
                src = fetchFromGitHub {
                  owner = "aserowy";
                  repo = "tmux.nvim";
                  rev = "307bad95a1274f7288aaee09694c25c8cbcd6f1a";
                  sha256 = "sha256-c/1swuJ6pIiaU8+i62Di/1L/b4V9+5WIVzVVSJJ4ls8=";
                };
              })
              # Must be the last plugin to be cofigured https://github.com/tmux-plugins/tmux-continuum#known-issues
              tmuxPlugins.continuum
            ];
        };
      };
    };
  };
}
