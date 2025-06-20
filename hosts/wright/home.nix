{ config
, lib
, pkgs
, inputs
, unstablePkgs
, ...
}: {
  imports = [
    ../_common/desktop.nix
    ../_common/linux/desktop.nix
    ../../programs/neovim/full-default.nix
  ];
  home.stateVersion = "22.11";
  home.username = "rick";
  home.homeDirectory = "/home/rick";

  home.packages = [
    pkgs.glibc
    pkgs.xdotool
    pkgs.feh
    pkgs.xorg.xmodmap
    pkgs.steam
    pkgs.ntfsprogs
    pkgs.prismlauncher
    pkgs.nvtopPackages.nvidia
    pkgs.rclone
    pkgs.freecad
    unstablePkgs.openscad-unstable
  ];

  programs.rofi.enable = true;
  systemd.user.startServices = true;
  # xfconf.settings.xfce4-keyboard-shortcuts = {
  #   "commands/custom/&lt;Super&gt;space" =
  #     "${pkgs.rofi}/bin/rofi -show run";
  #   "commands/custom/&lt;Super" =
  #     "xfce-popup-whiskermenu";
  # };
}
