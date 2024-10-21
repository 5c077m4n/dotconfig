{
  description = "MacOS system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nix-darwin,
      home-manager,
      ...
    }:
    let
      configName = "tickle";
      username = "roee";
      config = import ./darwin.nix {
        inherit self username;
      };
      inherit (nix-darwin.lib) darwinSystem;
    in
    {
      darwinConfigurations.${configName} = darwinSystem {
        modules = [
          config
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;

              users.${username} = import ./home.nix;
            };
          }
        ];
      };
      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations.${configName}.pkgs;
    };
}
