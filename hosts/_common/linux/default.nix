{ config
, lib
, pkgs
, inputs
, chosenfonts
, ...
}: {
  imports = [
    ./minimal.nix
  ];

  home.packages = with pkgs; [
    # utilities
    tigervnc
    firefox
    handbrake
    wireguard-tools
    nerdfonts
    xclip

    # cloud stuff
    awscli2
    oci-cli
    azure-cli
    doctl
    hcloud
    cloud-init
    nixos-generators

    # deployment
    morph
    viu
  ];
}
