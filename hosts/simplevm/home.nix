{ config, lib, pkgs, inputs, codeium-lsp, ... }:
{
  imports = [
    ../_common/default.nix
    ../_common/linux/default.nix
    ../../programs/neovim/full-nix.nix
    ../../programs/wezterm-linux.nix
  ];

  home.packages = [
    pkgs.xdotool
    pkgs.feh
    pkgs.xorg.xmodmap
    pkgs.xorg.setxkbmap
    codeium-lsp
  ];

  home.username = "rick";
  home.homeDirectory = "/home/rick";
}
