# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ pkgs, pkgs-unstable, ... }:
let
  stateVersion = "24.11";
in
{
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
  };

  services = {
    # Symlinks all `/nix/store/` binaries into `/bin` and `/usr/bin/` to help `$PATH` apps work
    envfs.enable = true;
  };

  system = { inherit stateVersion; };
}
