{ config, lib, pkgs, chosenfonts, inputs, ... }:
let
  unstable = import inputs.unstable {
    system = pkgs.system;
  };
in
{

  imports = [
    # ../../services/bspwm.nix
    # ../../services/sxhkd.nix
    ../../services/i3.nix
    ../_common/default.nix
    ../_common/linux/default.nix
  ];
  home.username = "rick";
  home.homeDirectory = "/home/rick";

  home.packages = [
    pkgs.polybar
    pkgs.rofi
    pkgs.tdrop
    pkgs.xdotool
    pkgs.feh
    pkgs.picom
    pkgs.i3lock
    pkgs.xss-lock
    pkgs.xorg.xmodmap
    pkgs.xorg.setxkbmap
  ];

  programs.rofi.enable = true;
  systemd.user.startServices = true;

}
