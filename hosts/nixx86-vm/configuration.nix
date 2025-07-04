{ config
, pkgs
, lib
, chosenfonts
, ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../_common/linux/configuration/boot.nix
    ../_common/linux/configuration/basic.nix
    ../_common/linux/configuration/xconfig-noi3.nix
    ../_common/linux/configuration/podman.nix
    ../_common/linux/configuration/impermanence.nix
    ../_common/linux/configuration/users-rick.nix
    ../_common/rick-passwordless-sudo.nix
  ];

  networking.hostName = "nixx86-vm";
  networking.hostId = "99a4b701";
  users.users.rick.shell = pkgs.zsh;

  environment.systemPackages = with pkgs; [
    firefox
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
    zsh
    xfce.xfce4-whiskermenu-plugin
  ];
  programs.zsh.enable = true;

  environment.pathsToLink = [ "/libexec" ];

  nix.optimise.automatic = true;
  system.stateVersion = "22.11";
}
