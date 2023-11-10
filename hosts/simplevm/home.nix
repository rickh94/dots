{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ../_common/default.nix
    ../_common/linux/default.nix
  ];

  home.packages = [
    pkgs.xdotool
    pkgs.feh
    pkgs.xorg.xmodmap
    pkgs.xorg.setxbkmap
    inputs.codeium.packages.x86_64-linux.codeium-lsp
  ];
  programs.rofi.enable = true;
  programs.user.startServices = true;
}
