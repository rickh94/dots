{ config, lib, pkgs, chosenfonts, inputs, unstablePkgs, ... }:
{

  imports = [
    ../_common/default.nix
    ../_common/linux/default.nix
  ];
  home.username = "rick";
  home.homeDirectory = "/home/rick";

  home.packages = [
    pkgs.killall
    pkgs.zellij
    pkgs.tmux
    pkgs.gibo
    pkgs.direnv
    pkgs.nix-direnv
    pkgs.gh
    pkgs.bacon
    pkgs.microserver
    pkgs.git-lfs
    pkgs.cargo-watch
    pkgs.proselint
    pkgs.poetry
    pkgs.mypy
    unstablePkgs.bun
    pkgs.wireguard-tools
    pkgs.morph
    (pkgs.nerdfonts.override { fonts = chosenfonts; })
    pkgs.awscli2
    pkgs.oci-cli
    pkgs.azure-cli
    pkgs.doctl
    pkgs.hcloud
    pkgs.cloud-init
    pkgs.nixos-generators
  ];

  programs.rofi.enable = true;
  systemd.user.startServices = true;

}
