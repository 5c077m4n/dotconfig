{
  description = "MacOS system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nix-darwin,
      ...
    }:
    let
      configName = "tickle";
      config =
        { pkgs, ... }:
        {
          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";

          environment = {
            variables = {
              EDITOR = "nvim";
              VISUAL = "nvim";
            };
            systemPackages = with pkgs; [
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
              # Window Tiling
              yabai
              skhd
              # LLMs
              ollama
              # Shells
              ## ZSH
              zsh
              beautysh
              ## Fish
              fish
              # JavaScript
              nodejs_22
              deno
              eslint_d
              prettierd
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
              pgcli
              mycli
              # Bluetooth
              blueutil
              # Fonts
              fira-mono
              hack-font
              # Misc
              gopass
              android-tools # ADB
              keepassxc
            ];
          };

          nix = {
            package = pkgs.nix;
            settings.experimental-features = "nix-command flakes";
            extraOptions = ''
              extra-platforms = x86_64-darwin aarch64-darwin
            '';
          };

          services = {
            # Auto upgrade nix package and the daemon service.
            nix-daemon.enable = true;

            yabai = {
              enable = true;
              package = pkgs.yabai;
            };
            skhd = {
              enable = true;
              package = pkgs.skhd;
            };
          };

          security.pam.enableSudoTouchIdAuth = true;

          programs = {
            # Create /etc/zshrc that loads the nix-darwin environment.
            zsh.enable = true;
            fish.enable = true;
          };

          system = {
            # Set Git commit hash for darwin-version.
            configurationRevision = self.rev or self.dirtyRev or null;

            # Used for backwards compatibility, please read the changelog before changing.
            # $ darwin-rebuild changelog
            stateVersion = 5;

            defaults = {
              dock = {
                autohide = true;
                mru-spaces = false;
              };

              finder = {
                AppleShowAllExtensions = true;
                AppleShowAllFiles = true;
                CreateDesktop = false;
                FXPreferredViewStyle = "clmv";
                QuitMenuItem = true;
              };

              screencapture.location = "~/Pictures/screenshots";
              screensaver.askForPasswordDelay = 10;

              NSGlobalDomain = {
                AppleShowAllFiles = true;
                KeyRepeat = 1;
              };
            };
          };

          homebrew = {
            enable = true;
            onActivation.cleanup = "zap";

            taps = [ ];
            brews = [ ];
            casks = [
              "arc"
              "firefox"
              "kitty"
              "iterm2"
              "vscodium"
              "displaylink"
              "inkscape"
              "lulu"
              "maccy"
              "karabiner-elements"
            ];
          };
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake ~/.config/nix/darwin#tickle
      darwinConfigurations.${configName} = nix-darwin.lib.darwinSystem {
        modules = [ config ];
      };
      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations.${configName}.pkgs;
    };
}
