{ config
, lib
, pkgs
, inputs
, ...
}: {
  imports = [
    ../_common/desktop.nix
    ../_common/linux/default.nix
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
    inputs.codeium.packages.x86_64-linux.codeium-lsp
  ];

  programs.rofi.enable = true;
  systemd.user.startServices = true;
}
