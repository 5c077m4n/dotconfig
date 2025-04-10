{
  description = "Unix systems flake";

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
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0-1.tar.gz";
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
      lix-module,
      ...
    }:
    let
      username = "roee";
      darwinConfigName = "${username}@macos";
      nixosConfigName = "${username}@nixos-vivo";
      ubuntuConfigName = "${username}@ubuntu-vivo";
      allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [ "google-chrome" ];
    in
    rec {
      darwinConfigurations.${darwinConfigName} =
        let
          system = "aarch64-darwin";
          pkgs = import nixpkgs-darwin { inherit system; };
          pkgs-unstable = import nixpkgs-unstable { inherit system; };
          home-manager-modules = [
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";

                extraSpecialArgs = {
                  inherit username pkgs-unstable;
                  homeDirectory = "/home/${username}";
                };
                users.${username} = ./flake/home;
              };
            }
          ];
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
          modules = [ ./flake/darwin/configuration.nix ] ++ home-manager-modules;
        };

      nixosConfigurations =
        let
          system = "x86_64-linux";
          pkgs = import nixpkgs {
            inherit system;
            config = { inherit allowUnfreePredicate; };
          };
          pkgs-unstable = import nixpkgs-unstable { inherit system; };
          specialArgs = {
            inherit
              self
              username
              system
              pkgs
              pkgs-unstable
              ;
          };
          home-manager-modules = [
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";

                extraSpecialArgs = {
                  inherit username pkgs-unstable;
                  homeDirectory = "/home/${username}";
                };
                users.${username} = ./flake/home;
              };
            }
          ];
        in
        {
          ${nixosConfigName} = nixpkgs.lib.nixosSystem {
            inherit pkgs specialArgs;
            modules = [
              lix-module.nixosModules.default
              ./flake/linux/nixos/configuration.nix
              ./flake/linux/nixos/hardware-configuration.nix
            ] ++ home-manager-modules;
          };
        };

      homeConfigurations = {
        ${darwinConfigName} =
          darwinConfigName.${darwinConfigName}.config.home-manager.users.${username}.home;
        ${nixosConfigName} =
          nixosConfigurations.${nixosConfigName}.config.home-manager.users.${username}.home;
        ${ubuntuConfigName} =
          let
            system = "x86_64-linux";
            pkgs = import nixpkgs {
              inherit system;
              config = { inherit allowUnfreePredicate; };
            };
            pkgs-unstable = import nixpkgs-unstable { inherit system; };
          in
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = {
              inherit username pkgs-unstable;
              homeDirectory = "/home/${username}";
            };
            modules = [ ./flake/home ];
          };
      };
    };
}
