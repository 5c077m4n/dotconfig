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
                pkgs.btop
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
                pkgs-unstable.fish
                pkgs-unstable.fishPlugins.fzf-fish
                pkgs-unstable.fishPlugins.autopair
                ## Misc
                ### Formatters
                pkgs.beautysh
                pkgs.shfmt
                pkgs.shellharden
                # JavaScript
                pkgs.nodejs_22
                pkgs.eslint_d
                pkgs.prettierd
                pkgs.pnpm
                pkgs.yarn-berry # `yarn` >=4.5
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
                ## Tools
                pkgs-unstable.air # Live reloader
                #pkgs-unstable.tinygo
                ## Formatters/Linters
                pkgs-unstable.golangci-lint
                pkgs-unstable.gofumpt
                pkgs-unstable.goimports-reviser
                pkgs-unstable.golines
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
                ## Browsers
                pkgs.floorp # Firefox alternative
                pkgs.google-chrome
                ## Terminal
                pkgs.kitty
                ## Clipboard manager
                pkgs.copyq
                ## Image viewer
                pkgs.feh
                ## Image editor
                pkgs.inkscape
                ## DB viewer
                pkgs-unstable.dbeaver-bin
                ## Office
                pkgs.libreoffice
              ]
              ++ lib.optionals stdenv.isDarwin [
                # Bluetooth
                pkgs.blueutil
              ];
          };

        programs = {
          home-manager.enable = true;

          fish = import ./apps/fish.nix { inherit pkgs-unstable; };
          tmux = import ./apps/tmux.nix { inherit config pkgs; };
        };
      };
  };
}
