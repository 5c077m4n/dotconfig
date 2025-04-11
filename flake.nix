{
  description = "MacOS system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
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
      nixpkgs-unstable,
      ...
    }:
    let
      configName = "tickle";
      username = "roee";
      hostPlatform = "aarch64-darwin";
      pkgs-unstable = nixpkgs-unstable.legacyPackages.${hostPlatform};
    in
    {
      darwinConfigurations.${configName} = nix-darwin.lib.darwinSystem {
        specialArgs = {
          inherit
            self
            username
            hostPlatform
            pkgs-unstable
            ;
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
