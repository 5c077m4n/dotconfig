{
  description = "Unix systems flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
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
          pkgs-unstable = import nixpkgs-unstable {
            inherit system;
            config = { inherit allowUnfreePredicate; };
          };
          home-manager-modules = [
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";

                extraSpecialArgs = {
                  inherit username pkgs-unstable;
                  homeDirectory = "/Users/${username}";
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
          pkgs-unstable = import nixpkgs-unstable {
            inherit system;
            config = { inherit allowUnfreePredicate; };
          };
          specialArgs = {
            inherit
              self
              username
              system
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
              ./flake/linux/nixos/configuration.nix
              ./flake/linux/nixos/hardware-configuration.nix
            ]
            ++ home-manager-modules;
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
            pkgs-unstable = import nixpkgs-unstable {
              inherit system;
              config = { inherit allowUnfreePredicate; };
            };
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
