
{ config, lib, pkgs, chosenfonts, inputs, ... }:
{

  imports = [
    ../_common/minimal.nix
    ../_common/linux/minimal.nix
    ../../programs/direnv/default.nix
    ../../programs/tmux.nix
  ];
  home.username = "rick";
  home.homeDirectory = "/home/rick";

  home.packages = [
    pkgs.ffmpeg
    pkgs.killall
    pkgs.zellij
    pkgs.atuin
    pkgs.tmux
    pkgs.gibo
    pkgs.direnv
    pkgs.nix-direnv
    pkgs.gh
    pkgs.bacon
    pkgs.cargo-expand
    pkgs.microserver
    pkgs.git-lfs
    pkgs.nodejs
    pkgs.nodePackages.pnpm
    pkgs.nodePackages.typescript
    pkgs.nodePackages.stylelint
    pkgs.cargo-watch
    pkgs.proselint
    pkgs.backblaze-b2
    pkgs.poetry
    pkgs.mypy
    pkgs.bun
    pkgs.wireguard-tools
    pkgs.morph
    pkgs.lilypond
    (pkgs.nerdfonts.override { fonts = chosenfonts; })
    pkgs.bitwarden
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
