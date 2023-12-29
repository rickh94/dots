{ config, lib, pkgs, ... }:
{

  imports = [
    ../_common/minimal.nix
    ../_common/linux/minimal.nix
    ../../programs/neovim/basic.nix
  ];
  home.username = "rick";
  home.homeDirectory = "/home/rick";
}
