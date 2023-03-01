{ config, lib, pkgs, ...}:
{

    imports = [
      ../minimal.nix
      ../minimal-linux.nix
    ];
    home.username = "rick";
    home.homeDirectory = "/home/rick";
}
