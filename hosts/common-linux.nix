{ config, lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    tigervnc
    firefox
    handbrake
    inkscape
    musescore
    steam
    (nerdfonts.override { fonts = [ "FiraCode" "Hack" "CascadiaCode" ]; })
    thunderbird
    glibc
    gimp
    krita
    vlc
    brave
    ungoogled-chromium
    prismlauncher
    spotify
    obs-studio
    davinci-resolve
    syncthing
    wireguard-tools
  ];
  programs.home-manager.enable = true;

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  programs.starship.enableNushellIntegration = false;
}
