{ config, lib, pkgs, nerdfonts, ... }:
{

  imports = [
    ../../services/bspwm.nix
    ../../services/sxhkd.nix
    ../_common/default.nix
    ../_common/linux/default.nix
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

  xsession.windowManager.bspwm.monitors = { "DP-4" = [ "www" "dev" "ent" "mus" "vnc" "virt" "VIII" "IX" ]; };

}
