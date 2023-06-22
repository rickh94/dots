{ config, pkgs, lib, chosenfonts, inputs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ../_common/linux/configuration/boot.nix
      ../_common/linux/configuration/basic.nix
      ../_common/linux/configuration/xconfig.nix
      ../_common/linux/configuration/virt.nix
      ../_common/linux/configuration/podman.nix
      ../_common/linux/configuration/users-rick.nix
      ./impermanence.nix
      ./nvidia.nix
      ./backup.nix
    ];



  networking.hostName = "beethoven";
  networking.hostId = "85462731";

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
    wireguard-tools
    tree
    curl
    pavucontrol
    podman
    podman-compose
    qemu_full
  ];

  environment.pathsToLink = [ "/libexec" ];


  # services.redis.servers.default.enable = true;
  # services.redis.servers.default.port = 6379;

}

