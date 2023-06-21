{ config, pkgs, lib, chosenfonts, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ../_common/linux/configuration/boot.nix
      ../_common/linux/configuration/basic.nix
      ../_common/linux/configuration/xconfig.nix
      ../_common/linux/configuration/podman.nix
      ../_common/linux/configuration/impermanence.nix
      ../_common/linux/configuration/users-rick.nix
    ];

  networking.hostName = "nixarm-vm";
  networking.hostId = "99a4b702";

  environment.systemPackages = with pkgs; [
    firefox
    (nerdfonts.override { fonts = chosenfonts; })
    neovim
    git
    alacritty
    xorg.xinit
    killall
    xdotool
    xorg.xwininfo
    lightdm-slick-greeter
    nushell
    wireguard-tools
    tree
    curl
    podman
    podman-compose
  ];

  environment.pathsToLink = [ "/libexec" ];

}

