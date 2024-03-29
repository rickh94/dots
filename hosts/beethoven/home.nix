{ config, lib, pkgs, chosenfonts, inputs, ... }:
{

  imports = [
    ../../services/i3.nix
    ../_common/desktop.nix
    ../_common/linux/desktop.nix
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
    inputs.codeium.packages.x86_64-linux.codeium-lsp
  ];

  programs.rofi.enable = true;
  systemd.user.startServices = true;

}
