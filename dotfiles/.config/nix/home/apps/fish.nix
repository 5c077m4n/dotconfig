{ pkgs }:
let
  inherit (pkgs) fish fishPlugins;
in
{
  enable = true;
  package = fish;

  plugins = [
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
