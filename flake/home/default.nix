{
  pkgs,
  pkgs-unstable,
  username,
  config,
  homeDirectory,
  ...
}:
let
  stateVersion = "24.11";
  isNixOS = builtins.pathExists "/etc/nixos/";
  inherit (pkgs) lib;
in
{
  home = {
    inherit username homeDirectory stateVersion;

    packages =
      let
        inherit (pkgs.stdenv) isLinux isDarwin;
      in
      [
        # General
        ## Text editors
        pkgs-unstable.neovim
        ## Tooling
        pkgs.curl
        pkgs.wget
        pkgs.coreutils
        pkgs.openssh
        pkgs.less
        pkgs.gzip
        pkgs.unzip
        pkgs.ps
        pkgs.busybox
        pkgs.gnumake
        pkgs.gcc
        pkgs.gnupg
        pkgs.stow
        # VCS
        ## Git
        pkgs.git
        ### Tooling
        pkgs.hub
        pkgs.lazygit
        pkgs.delta
        pkgs.git-absorb
        # TUI
        pkgs.tmux
        pkgs.starship
        pkgs.btop
        pkgs.htop
        pkgs.lf
        pkgs.eza
        pkgs.bat
        pkgs.procs
        pkgs.jq
        pkgs.yq
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
        ## Runtimes
        pkgs.nodejs_22
        pkgs-unstable.deno
        ## Package managers
        pkgs.pnpm
        pkgs.yarn-berry # `yarn` >=4.5
        ## Linters
        pkgs.eslint_d
        pkgs.prettierd
        pkgs.stylelint
        # Python
        pkgs-unstable.python310
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
        pkgs.podman
        pkgs.podman-compose
        ### deps
        pkgs.virtiofsd
        ## Linter
        pkgs.hadolint
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
      ++ lib.optionals isLinux [
        # CLI utils
        ## Clipboard
        pkgs.xclip
        ## Audio control
        pkgs.pulseaudio
        ## Screen brightness control
        pkgs.brightnessctl
        ## Battery data
        pkgs.acpi
      ]
      ++ lib.optionals (isLinux && isNixOS) [
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
      ++ lib.optionals isDarwin [
        # Bluetooth
        pkgs.blueutil
      ];

    sessionVariables = {
      # Allows linkers to find nix packages
      NIX_LD_LIBRARY_PATH =
        let
          inherit (pkgs) stdenv zlib;
        in
        lib.makeLibraryPath [
          stdenv.cc.cc
          zlib
        ];
    };
  };

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };

  programs = {
    home-manager.enable = true;

    fish = import ./apps/fish.nix { inherit pkgs-unstable; };
    tmux = import ./apps/tmux.nix { inherit config pkgs; };
  };

  services = {
    podman.enable = true;
  };

  fonts.fontconfig.enable = true;
  news = {
    display = "silent";
    entries = lib.mkForce [ ];
  };
}
