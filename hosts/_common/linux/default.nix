{ config, lib, pkgs, inputs, chosenfonts, ... }:
let
  unstable = import inputs.unstable {
    system = pkgs.system;
  };
in
{
  imports = [
    ./minimal.nix
  ];

  home.packages = with pkgs; [
    # utilities
    tigervnc
    firefox
    handbrake
    (nerdfonts.override { fonts = chosenfonts; })
    thunderbird
    vlc
    brave
    ungoogled-chromium
    spotify
    syncthing
    wireguard-tools
    bitwarden
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
    terraform
    terraform-providers.docker
    terraform-providers.oci
    terraform-providers.aws
    terraform-providers.ibm
    terraform-providers.digitalocean
    terraform-providers.linode
    terraform-providers.libvirt

    # creative
    unstable.musescore
    inkscape
    gimp
    krita
    obs-studio
    davinci-resolve
    lilypond
    okular

    # gaming
    steam
    prismlauncher

  ];
}
