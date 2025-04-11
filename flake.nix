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
    in
    {
      darwinConfigurations.${configName} = nix-darwin.lib.darwinSystem {
        specialArgs = {
          inherit self username;
        };
        modules = [
          (import ./darwin.nix)
          home-manager.darwinModules.home-manager
          (import ./home.nix)
        ];
      };
      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations.${configName}.pkgs;
    };
}
