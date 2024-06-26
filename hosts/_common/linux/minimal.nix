{ config
, lib
, pkgs
, ...
}: {
  home.packages = with pkgs; [
    # utilities
    firefox
    wireguard-tools
    gcc12
    glibc

    # virtualization
    podman
    virt-manager
    virt-viewer
    rename
  ];

  programs.home-manager.enable = true;

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };
}
