{ pkgs, ... }:
let
  wez = (import ./wez-config.nix { inherit pkgs; });
in
{
  programs.wezterm = {
    enable = true;
    extraConfig = wez.text;
  };
}
