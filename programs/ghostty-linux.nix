{ pkgs, ... }:
let
  ghost = (import ./ghostty-config.nix { inherit pkgs; });
in
{
  programs.ghostty = {
    enable = true;
    extraConfig = ghost.text;
  };
}
