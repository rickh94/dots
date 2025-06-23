{ pkgs
, ...
}:
let
  bacon-config = (import ../../../programs/bacon-config.nix { });
  bacon-text = bacon-config.text;
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

  xdg.configFile."bacon/prefs.toml".text = bacon-text;
}
