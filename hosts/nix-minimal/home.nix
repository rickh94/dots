{ config, lib, pkgs, inputs, ... }:
{

  imports = [
    ../_common/default.nix
    ../_common/linux/default.nix
    ../../programs/neovim/basic.nix
    ../../programs/ghostty-linux.nix
  ];
  home.username = "rick";
  home.homeDirectory = "/home/rick";

  home.packages = [
    pkgs.glibc
    pkgs.xdotool
    pkgs.feh
    pkgs.xorg.xmodmap
    pkgs.xorg.setxkbmap
    pkgs.ghostty
  ];


  programs.rofi.enable = true;
  systemd.user.startServices = true;

}
