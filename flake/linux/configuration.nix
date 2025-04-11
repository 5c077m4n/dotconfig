# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ pkgs, ... }:
let
  stateVersion = "24.11";
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd.luks.devices."luks-6094072e-94b1-45a4-88f3-548832c8ffc3".device =
      "/dev/disk/by-uuid/6094072e-94b1-45a4-88f3-548832c8ffc3";
  };

  networking = {
    hostName = "nixos"; # Define your hostname.
    wireless.enable = false; # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    #proxy = {
    #  default = "http://user:password@proxy:port/";
    #  noProxy = "127.0.0.1,localhost,internal.domain";
    #};

    # Enable networking
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

    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 80;

        # [Optional] helps save long term battery health
        START_CHARGE_THRESH_BAT0 = 40; # below it start to charge
        STOP_CHARGE_THRESH_BAT0 = 80; # above it stop charging

        # Always run on battery mode (in case of overheating on AC power)
        #TLP_DEFAULT_MODE = "BAT";
        #TLP_PERSISTENT_DEFAULT = 1;
      };
    };
  };

  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        vpl-gpu-rt # intel graphics driver
      ];
    };
    pulseaudio.enable = false;
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

    shell = pkgs.fish;
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
    systemPackages = with pkgs; [
      fish
      neovim
      curl
      wget
      python3
      gcc
      gnumake
    ];
    pathsToLink = [ "/libexec" ]; # links `/libexec` from derivations to `/run/current-system/sw`
  };

  programs = {
    fish.enable = true;

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
