{ pkgs-unstable }:
{
  enable = true;
  package = pkgs-unstable.fish;

  plugins =
    let
      inherit (pkgs-unstable) fishPlugins;
    in
    [
      {
        name = "fzf-fish";
        inherit (fishPlugins.fzf-fish) src;
      }
      {
        name = "autopair";
        inherit (fishPlugins.autopair) src;
      }
    ];
}
