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
    enable = false; # This disables `nix-darwin` from managing nix itself, Determinate nix does this already
    settings.experimental-features = "nix-command flakes";
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  system = {
    primaryUser = username;

    # Set Git commit hash for darwin-version.
    configurationRevision = self.rev or self.dirtyRev or null;

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 5;

    defaults = {
      dock = {
        autohide = true;
        mru-spaces = false;
        magnification = true;
        minimize-to-application = true;
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
        InitialKeyRepeat = 9;
        NSWindowShouldDragOnGesture = true;
        NSAutomaticWindowAnimationsEnabled = false;
      };
    };
  };

  programs = {
    fish = {
      enable = true;
      package = pkgs.fish;
    };
  };

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";

    shell = pkgs.fish;
  };

  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };

    taps = [
      "nikitabobko/tap"
      "Arthur-Ficial/tap"
    ];
    brews = [
      "go"
      "swift-format"
      "dockutil"
      "Arthur-Ficial/tap/apfel"
      "docker"
      "docker-completion"
    ];
    casks = [
      "docker-desktop"
      "karabiner-elements"
      "libreoffice"
      "zen"
      "ghostty"
      "iterm2"
      "vscodium"
      "inkscape"
      "nikitabobko/tap/aerospace"
      "maccy"
      "keepassxc"
      "mongodb-compass"
      "android-studio"
      "unnaturalscrollwheels"
    ];
  };
}
