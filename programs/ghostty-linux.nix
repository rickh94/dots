{ pkgs, ... }:
let
  ghost = (import ./ghostty-config.nix { inherit pkgs; });
in
{
  programs.ghostty = {
    enable = true;
  };
  xdg.configFile."ghostty/config" = {
    text = ghost.text;
  };
}
