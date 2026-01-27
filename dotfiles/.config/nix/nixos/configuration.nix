{ pkgs, pkgs-unstable, ... }:
let
  stateVersion = "24.11";
in
{
  imports = [ ./hardware-configuration.nix ];

  boot =
    let
      device-luks-id = "6094072e-94b1-45a4-88f3-548832c8ffc3";
    in
    {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
      initrd.luks.devices."luks-${device-luks-id}".device = "/dev/disk/by-uuid/${device-luks-id}";
    };

  networking = {
    hostName = "nixos"; # Define your hostname.
    wireless.enable = false; # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    #proxy = {
    #  default = "http://user:password@proxy:port/";
    #  noProxy = "127.0.0.1,localhost,internal.domain";
    #};

    networkmanager.enable = true;
    firewall = {
      enable = true;

      allowedTCPPorts = [
        22
        80
        443
      ];
      allowedUDPPorts = [ 10002 ];
    };
  };

  # Set your time zone.
  time.timeZone = "Asia/Jerusalem";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  services = {
    # Symlinks all `/nix/store/` binaries into `/bin` and `/usr/bin/` to help `$PATH` apps work
    envfs.enable = true;

    displayManager.defaultSession = "xfce+i3";
    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
    pulseaudio.enable = false;

    xserver = {
      enable = true;

      desktopManager = {
        xterm.enable = false;
        xfce = {
          enable = true;
          noDesktop = true;
          enableXfwm = false;
          enableScreensaver = false;
        };
      };
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          rofi # application launcher
          i3lock # default i3 screen locker
          xss-lock # locks screen before suspend
          polybar # status bar
          xorg.xmodmap # keymapper
          picom # a better compositor
        ];
      };

      # Configure keymap in X11
      xkb.layout = "us,il";
    };

    # Enable CUPS to print documents.
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };

    auto-cpufreq.enable = true;
  };

  hardware = {
    graphics = {
      enable = true;
      extraPackages = [
        pkgs.vpl-gpu-rt # intel graphics driver
      ];
    };
  };
  security.rtkit.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.roee = {
    isNormalUser = true;
    description = "Roee";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = [ ];

    shell = pkgs-unstable.fish;
    useDefaultShell = true;
  };

  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    systemPackages = [
      pkgs.fish
      pkgs.neovim
      pkgs.curl
      pkgs.wget
      pkgs.python3
      pkgs.gcc
      pkgs.gnumake
    ];
    pathsToLink = [ "/libexec" ]; # links `/libexec` from derivations to `/run/current-system/sw`
  };

  programs = {
    fish = {
      enable = true;
      package = pkgs-unstable.fish;
    };

    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc.lib
        zlib
      ];
    };

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    #mtr.enable = true;
    #gnupg.agent = {
    #  enable = true;
    #  enableSSHSupport = true;
    #};
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system = { inherit stateVersion; };
}
