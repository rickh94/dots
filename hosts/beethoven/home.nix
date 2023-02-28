{ config, lib, pkgs, ...}:
{

    imports = [
      ../../services/bspwm.nix
      ../../services/sxhkd.nix
      ../common.nix
      ../common-linux.nix
    ];
    home.username = "rick";
    home.homeDirectory = "/home/rick";

    home.packages = with pkgs; [
      polybar
      rofi
      tdrop
      xdotool
      feh
    ];


    programs.rofi.enable = true;
    systemd.user.startServices = true;

  home.file."Wallpapers/wallpapers.txt" = {
    enable = true;
    source = ../../wallpapers/wallpapers.txt;
    onChange = ''
      #!/usr/bin/env bash
      cd $HOME/Wallpapers
      ${pkgs.wget}/bin/wget -v -i wallpapers.txt
    '';

  };
}
