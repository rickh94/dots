{ config, lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    # utilities
    firefox
    wireguard-tools

    # virtualization
    podman
    virt-manager
    virt-viewer
  ];

  programs.home-manager.enable = true;

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

}
