{
  self,
  pkgs,
  username,
  hostPlatform,
  ...
}:
{
  nixpkgs = { inherit hostPlatform; };

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

  programs = {
    fish.enable = true;
  };

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";

    shell = pkgs.fish;
  };

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";

    taps = [ ];
    brews = [ ];
    casks = [
      "displaylink"
      "lulu"
      "karabiner-elements"
      "libreoffice"
      "zen-browser"
    ];
  };
}
