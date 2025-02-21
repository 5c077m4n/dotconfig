{ pkgs }:
{
  enable = true;

  plugins =
    let
      inherit (pkgs) fishPlugins;
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
