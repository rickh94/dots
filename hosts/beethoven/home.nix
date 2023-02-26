{ config, lib, pkgs, ...}:
{

    imports = [
      ../../services/bspwm.nix
      ../../services/sxhkd.nix
      ../../services/polybar.nix
      ../common.nix
      ../common-linux.nix
    ];
    home.username = "rick";
    home.homeDirectory = "/home/rick";

    home.packages = with pkgs; [
      polybar
      rofi
      tdrop
      xdotool
      feh
      picom
    ];


    programs.rofi.enable = true;
    services.picom.enable = true;
}
