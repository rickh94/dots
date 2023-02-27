{ config, lib, pkgs, ...}:
{
  home.packages = with pkgs; [
    tigervnc
    firefox
      handbrake
      inkscape
      musescore
      steam
      neovide
      (nerdfonts.override { fonts = ["FiraCode" "Hack" "CascadiaCode"];})
      thunderbird
      glibc
      gimp
      krita
      vlc
      kitty
      brave
      ungoogled-chromium
      prismlauncher
      spotify
      obs-studio
      davinci-resolve
      syncthing
      wireguard-tools
  ];

  nix = {
    package = pkgs.nix;
    settings.experimental-features = ["nix-command" "flakes"];
  };
}
