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
    (nerdfonts.override { fonts = chosenfonts; })
    wireguard-tools
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
