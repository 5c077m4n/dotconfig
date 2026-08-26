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

  networking.applicationFirewall = {
    enable = true;
    enableStealthMode = true;
    blockAllIncoming = true;
    allowSigned = false;
    allowSignedApp = false;
  };

  services.openssh.enable = false;

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
        show-process-indicators = true;
      };
      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        CreateDesktop = false;
        FXPreferredViewStyle = "clmv";
        QuitMenuItem = true;
      };
      loginwindow = {
        GuestEnabled = false;
        DisableConsoleAccess = true;
      };
      screencapture.location = "~/Pictures/screenshots";
      screensaver = {
        askForPassword = true;
        askForPasswordDelay = 5;
      };
      NSGlobalDomain = {
        KeyRepeat = 1;
        InitialKeyRepeat = 9;
        NSWindowShouldDragOnGesture = true;
        NSAutomaticWindowAnimationsEnabled = false;
        "com.apple.keyboard.fnState" = true;
      };
      CustomSystemPreferences = {
        "com.apple.SubmitDiagInfo" = {
          AutoSubmit = false;
          AutoSubmitThirdParty = false;
        };
        "com.apple.assistant.support" = {
          "Siri Data Sharing Opt-In Status" = 2; # 1 = Opted In, 2 = Declined/Opted Out
          "AppleIntelligenceReportDuration" = 0; # 0 = Off, 1 = 15 Mins, 2 = 7 Days
        };
        "com.apple.Siri" = {
          AppleIntelligenceEnabled = false;
          LLMEnable = false;
        };
      };
    };

    activationScripts.extraActivation.text = ''
      if ! fdesetup status | grep -q "FileVault is On."; then
        sudo fdesetup enable
      fi
    '';
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

    taps = [ "nikitabobko/tap" ];
    brews = [
      "go"
      "swift-format"
      "dockutil"
      "blueutil"
      "docker-completion"
      "tree-sitter-cli"
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
