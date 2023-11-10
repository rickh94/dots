{ config, pkgs, lib, chosenfonts, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../_common/linux/configuration/boot.nix
    ../_common/linux/configuration/basic.nix
    ../_common/linux/configuration/xconfig-noi3.nix
    ../_common/linux/configuration/users-rick.nix
  ];

  networking.hostName = "nixarm-vm2";
  networking.hostId = "9ca4b702";

  users.users = {
    rick = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "libvirtd" ]; # Enable ‘sudo’ for the user.
      uid = 1000;
    };
  };

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
  ];

  environment.pathsToLink = [ "/libexec" ];
}
