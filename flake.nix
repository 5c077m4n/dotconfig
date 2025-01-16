{
  description = "MacOS system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
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
      nixpkgs-unstable,
      ...
    }:
    let
      username = "roee";
      hostPlatform = "aarch64-darwin";
      configName = "tickle";
    in
    {
      darwinConfigurations.${configName} = nix-darwin.lib.darwinSystem {
        specialArgs = {
          inherit self username hostPlatform;
          pkgs-unstable = import nixpkgs-unstable {
            system = hostPlatform;
          };
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
