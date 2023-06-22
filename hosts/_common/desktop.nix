{ config, pkgs, nixpkgs, lib, ... }:
{
  imports = [
    ./default.nix
  ];
  home.packages = with pkgs; [
    zoom-us
    vscodium

  ];

  home.file."Wallpapers/wallpapers.txt" = {
    enable = true;
    source = ../../wallpapers/wallpapers.txt;
    onChange = ''
      #!/usr/bin/env bash
      cd $HOME/Wallpapers
      ${pkgs.wget}/bin/wget -nc -i wallpapers.txt
    '';
  };
}
