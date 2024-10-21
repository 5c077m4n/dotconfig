{
  self,
  username,
}:
{
  pkgs,
  ...
}:
let
  hostPlatform = "aarch64-darwin";
in
{
  nixpkgs = {
    # The platform the configuration will be used on.
    inherit hostPlatform;
  };

  nix = {
    package = pkgs.nix;
    settings.experimental-features = "nix-command flakes";

    # Garbage collect the Nix store
    gc.automatic = true;

    extraOptions = ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
  };

  services = {
    # Auto upgrade nix package and the daemon service.
    nix-daemon.enable = true;
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
        NSWindowShouldDragOnGesture = true;
        NSAutomaticWindowAnimationsEnabled = false;
      };
    };
  };

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";

    taps = [ "nikitabobko/tap" ];
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
      "libreoffice"
      "nikitabobko/tap/aerospace"
    ];
  };
}
