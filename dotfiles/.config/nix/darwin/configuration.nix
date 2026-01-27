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
    enable = false;
    settings.experimental-features = "nix-command flakes";

    # package = pkgs.lixPackageSets.stable.lix;
    # optimise.automatic = true;
    # # Garbage collect the Nix store
    # gc = {
    #   automatic = true;
    #   interval = {
    #     Hour = 0;
    #     Minute = 0;
    #   };
    #   options = "--delete-older-than 7d";
    # };
    # extraOptions = ''
    #   extra-platforms = x86_64-darwin aarch64-darwin
    # '';
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
    onActivation.cleanup = "zap";

    taps = [ "nikitabobko/tap" ];
    brews = [
      "sleepwatcher"
      "go"
      "swift-format"
      "docker-compose"
      "dockutil"
    ];
    casks = [
      "docker-desktop"
      "karabiner-elements"
      "libreoffice"
      "zen"
      "kitty"
      "iterm2"
      "neovide-app"
      "vscodium"
      "inkscape"
      "nikitabobko/tap/aerospace"
      "maccy"
      "keepassxc"
      "mongodb-compass"
      "android-studio"
    ];
  };
}
