{ config, lib, pkgs, ... }:
{
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

    # virtualization
    podman
    virt-manager
    virt-viewer

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
  programs.home-manager.enable = true;

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  programs.starship.enableNushellIntegration = false;
}
