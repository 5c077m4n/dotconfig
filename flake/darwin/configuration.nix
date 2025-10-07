{
  self,
  pkgs,
  pkgs-unstable,
  username,
  hostPlatform,
  ...
}:
{
  nixpkgs = { inherit hostPlatform; };

  nix = {
    enable = false;

    # package = pkgs.lixPackageSets.stable.lix;
    # optimise.automatic = true;
    # settings.experimental-features = "nix-command flakes";
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
      package = pkgs-unstable.fish;
    };
  };

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";

    shell = pkgs-unstable.fish;
  };

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";

    taps = [
      "nikitabobko/tap"
    ];
    brews = [ ];
    casks = [
      "displaylink"
      "lulu"
      "karabiner-elements"
      "libreoffice"
      "zen"
      "arc"
      "kitty"
      "iterm2"
      "neovide-app"
      "vscodium"
      "inkscape"
      "nikitabobko/tap/aerospace"
      "maccy"
      "keepassxc"
    ];
  };
}
