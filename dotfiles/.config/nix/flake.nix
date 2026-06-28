{
  description = "Unix systems flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nix-darwin,
      home-manager,
      nixpkgs,
      nixpkgs-unstable,
      determinate,
      ...
    }:
    let
      username = "roee";
      darwinConfigName = "${username}@macos";
      allowUnfreePredicate =
        pkg:
        builtins.elem (nixpkgs.lib.getName pkg) [
          "google-chrome"
          "claude-code"
        ];
    in
    {
      darwinConfigurations.${darwinConfigName} =
        let
          system = "aarch64-darwin";
          pkgs = import nixpkgs {
            inherit system;
            config = { inherit allowUnfreePredicate; };
          };
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
                users.${username} = ./home;
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
          modules = [
            determinate.darwinModules.default
            ./darwin/configuration.nix
          ]
          ++ home-manager-modules;
        };
    };
}
