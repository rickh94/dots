{ config, lib, pkgs, ...}:
{

    imports = [
      ../../services/bspwm.nix
      ../../services/sxhkd.nix
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
    ];


    programs.rofi.enable = true;
    systemd.user.startServices = true;

}
