{
  pkgs,
  pkgs-unstable,
  username,
  config,
  homeDirectory,
  ...
}:
let
  stateVersion = "25.05";
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
        pkgs.ps
        pkgs.gnumake
        pkgs.gcc
        pkgs.gnupg
        pkgs.stow
        pkgs.inotify-tools
        pkgs.gnugrep
        pkgs.gnupg
        pkgs.gnused
        pkgs.gnutar
        pkgs.bzip2
        pkgs.gzip
        pkgs.xz
        pkgs.zip
        pkgs.unzip
        pkgs.procps
        pkgs.killall
        pkgs.diffutils
        pkgs.findutils
        pkgs.utillinux
        pkgs.tzdata
        pkgs.hostname
        pkgs.man
        ### AI
        pkgs-unstable.opencode
        # VCS
        ## Git
        pkgs.git
        ### Tooling
        pkgs.hub
        pkgs.lazygit
        pkgs.delta
        pkgs.git-absorb
        pkgs.gitleaks
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
        pkgs-unstable.ollama
        # Shells
        ## Bash
        pkgs.bash
        ## ZSH
        pkgs.zsh
        ## Fish
        pkgs-unstable.fish
        pkgs-unstable.fish-lsp
        pkgs-unstable.fishPlugins.fzf-fish
        pkgs-unstable.fishPlugins.autopair
        ## Misc
        ### Formatters
        pkgs.beautysh
        pkgs.shfmt
        pkgs.shellharden
        # TypeScript/JavaScript
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
        pkgs-unstable.biome
        # Python
        pkgs-unstable.python310
        pkgs-unstable.poetry
        pkgs-unstable.mypy
        pkgs-unstable.pylint
        pkgs-unstable.black
        pkgs-unstable.isort
        pkgs-unstable.ruff
        pkgs-unstable.pyright
        # Golang
        pkgs-unstable.go
        ## Tools
        pkgs-unstable.air # Live reloader
        pkgs-unstable.tinygo
        ## LSP
        pkgs-unstable.gopls
        ## Formatters/Linters
        pkgs-unstable.golangci-lint
        pkgs-unstable.gofumpt
        pkgs-unstable.goimports-reviser
        pkgs-unstable.golines
        # Rust
        pkgs-unstable.rustup
        pkgs-unstable.cargo-insta # Snapshot testing
        pkgs-unstable.cargo-nextest # Rust testing CLI
        pkgs-unstable.pkg-config
        pkgs-unstable.openssl
        # Zig
        pkgs.zig
        pkgs.zls
        # Lua
        pkgs.luajit
        pkgs.luajitPackages.luacheck
        pkgs.luarocks
        pkgs-unstable.stylua
        pkgs-unstable.selene
        # Nix
        pkgs.nixfmt-rfc-style
        pkgs.statix
        pkgs.deadnix
        pkgs.nil
        pkgs.nixd
        # WASM
        pkgs-unstable.wasmtime
        # Gleam
        pkgs-unstable.gleam
        pkgs-unstable.erlang
        # Jsonnet
        pkgs-unstable.go-jsonnet
        pkgs-unstable.jsonnet-language-server
        # YAML
        pkgs.yamllint
        # Markdown
        pkgs.marksman
        # K8s
        pkgs-unstable.kubectx
        pkgs-unstable.k9s
        # Containers
        ## Docker
        #pkgs-unstable.docker
        #pkgs-unstable.docker-compose
        ## Utils
        ### Linter
        pkgs.hadolint
        # DBs
        ## TUIs
        pkgs.pgcli
        pkgs.mycli
        ## SQL
        ### Formatters
        pkgs.sqlfluff
        # Fonts
        pkgs.nerd-fonts.fira-mono
        pkgs.nerd-fonts.hack
        # Cloud
        pkgs.awscli2
        pkgs.awslogs
        # Misc
        pkgs.gopass
        pkgs.android-tools # ADB
      ]
      ++ lib.optionals isLinux [
        # Audio
        pkgs.pulseaudio
        pkgs.pipewire
        # CLI utils
        ## Clipboard
        pkgs.xclip
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
    tmux = import ./apps/tmux.nix { inherit config pkgs pkgs-unstable; };
  };

  fonts.fontconfig.enable = true;
  news = {
    display = "silent";
    entries = lib.mkForce [ ];
  };
}
