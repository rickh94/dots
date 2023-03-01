{ config, lib, pkgs, ... }:
{
  imports = [
    ./minimal-linux.nix
  ];

  home.packages = with pkgs; [
    # utilities
    tigervnc
    firefox
    handbrake
    (nerdfonts.override { fonts = [ "FiraCode" "Hack" "CascadiaCode" ]; })
    thunderbird
    vlc
    brave
    ungoogled-chromium
    spotify
    syncthing
    wireguard-tools


    # creative
    musescore
    inkscape
    gimp
    krita
    obs-studio
    davinci-resolve

    # gaming
    steam
    prismlauncher

  ];
}
