{ config
, lib
, pkgs
, inputs
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
  ];

  programs.rofi.enable = true;
  systemd.user.startServices = true;
  home.xfconf.xfce4-keyboard-shortcuts = {
    "commands/custom/&lt;Super&gt;space" =
      "${pkgs.rofi}/bin/rofi -show run";
  };
}
