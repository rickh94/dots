{ config, lib, pkgs, inputs, chosenfonts, ... }:
{
  imports = [
    ./default.nix
  ];
  home.packages = with pkgs;
    [

      thunderbird
      vlc
      brave
      ungoogled-chromium
      spotify
      syncthing
      bitwarden
      musescore
      inkscape
      gimp
      krita
      obs-studio
      lilypond
      okular

      # utils
      flameshot
      nomacs
    ];
}
