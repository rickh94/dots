{ config, pkgs, nixpkgs, lib, ... }:
{
  imports = [
    ./default.nix
  ];
  home.packages = with pkgs; [
    zoom-us
    vscodium

  ];
}
