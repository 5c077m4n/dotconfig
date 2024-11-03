{ pkgs, username, ... }:
let
  stateVersion = "24.11";
in
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";

    users.${username} = {
      home = {
        inherit stateVersion;

        packages = with pkgs; [
          # General
          neovim
          tmux
          htop
          curl
          wget
          coreutils
          jq
          yq
          openssh
          # VCS
          git
          hub
          lazygit
          delta
          git-absorb
          # TUI
          starship
          ranger
          eza
          bat
          # Search
          fd
          fzf
          ripgrep
          # LLMs
          ollama
          # Shells
          ## ZSH
          zsh
          beautysh
          ## Fish
          fish
          fishPlugins.fzf-fish
          fishPlugins.autopair
          # JavaScript
          nodejs_22
          deno
          eslint_d
          prettierd
          pnpm
          yarn-berry # `yarn` >=4.5
          # Python
          python313
          pyenv
          poetry
          mypy
          pylint
          black
          isort
          # Golang
          go
          golangci-lint
          # Rust
          rustup
          # Zig
          zig
          zls
          # Lua
          luajit
          luajitPackages.luacheck
          luarocks
          stylua
          selene
          # Nix
          nixfmt-rfc-style
          statix
          deadnix
          nil
          # K8s
          kubectx
          k9s
          # Docker
          docker_27
          # DBs
          ## TUIs
          pgcli
          mycli
          # Bluetooth
          blueutil
          # Fonts
          (nerdfonts.override {
            fonts = [
              "FiraMono"
              "Hack"
            ];
          })
          # Misc
          gopass
          android-tools # ADB
          keepassxc
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

        sessionVariables = {
          EDITOR = "nvim";
          VISUAL = "nvim";
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
      };
    };
  };
}
