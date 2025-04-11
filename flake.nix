{
  description = "Unix system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nix-darwin,
      home-manager,
      nixpkgs,
      nixpkgs-darwin,
      nixpkgs-unstable,
      ...
    }:
    let
      username = "roee";
      configName = "tickle";
    in
    {
      darwinConfigurations.${configName} =
        let
          system = "aarch64-darwin";
          pkgs = import nixpkgs-darwin { inherit system; };
          pkgs-unstable = import nixpkgs-unstable { inherit system; };
        in
        nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit
              self
              username
              pkgs
              pkgs-unstable
              ;
            hostPlatform = system;
          };
          modules = [
            (import ./flake/darwin-configuration.nix)
            home-manager.darwinModules.home-manager
            (import ./flake/home.nix)
          ];
        };
      darwinPackages = self.darwinConfigurations.${configName}.pkgs;

      nixosConfigurations.${configName} =
        let
          system = "x86_64-linux";
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [ "google-chrome" ];
          };
          pkgs-unstable = import nixpkgs-unstable { inherit system; };
        in
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit
              self
              username
              system
              pkgs
              pkgs-unstable
              ;
          };
          modules = [
            ./flake/configuration.nix
            ./flake/hardware-configuration.nix

            home-manager.nixosModules.home-manager
            (import ./flake/home.nix)
          ];
        };
      nixosPackages = self.nixosConfigurations.${configName}.pkgs;
    };
}
