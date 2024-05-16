{ config, lib, pkgs, inputs, ... }:
{

  imports = [
    ../_common/default.nix
    ../_common/linux/default.nix
    ../../programs/neovim/basic.nix
  ];
  home.username = "rick";
  home.homeDirectory = "/home/rick";

  home.packages = [
    pkgs.glibc
    pkgs.xdotool
    pkgs.feh
    pkgs.xorg.xmodmap
    pkgs.xorg.setxkbmap
    inputs.codeium.packages.x86_64-linux.codeium-lsp
  ];


  programs.rofi.enable = true;
  systemd.user.startServices = true;

}
