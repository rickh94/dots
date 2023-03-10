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


    # creative
    unstable.musescore
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
