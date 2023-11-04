{ config, pkgs, ... }:
let
  wez = (import ./wez-config.nix { inherit pkgs; });
in
{
  xdg.configFile."wezterm/wezterm.lua" = {
    text = wez.text;
  };
}
