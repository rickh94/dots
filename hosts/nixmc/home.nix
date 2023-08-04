{ config, lib, pkgs, ... }:
{

  imports = [
    ../_common/minimal.nix
    ../_common/linux/minimal.nix
  ];
  home.username = "rick";
  home.homeDirectory = "/home/rick";
}
