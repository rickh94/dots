{ pkgs, ... }:
let
  ghost = (import ./ghostty-config.nix { inherit pkgs; });
in
{
  xdg.configFile."ghostty/config" = {
    text = ghost.text;
  };
}
