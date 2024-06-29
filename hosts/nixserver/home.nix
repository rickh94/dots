{ config, lib, pkgs, ... }:
{

  imports = [
    ../_common/minimal.nix
    ../_common/linux/minimal.nix
    ../../programs/neovim/basic.nix
    ../../programs/direnv/default.nix
    ../../programs/atuin.nix
  ];
  home.username = "rick";
  home.homeDirectory = "/home/rick";
  home.sessionVariables = {
    EDITOR = "nvim";
    MAKEFLAGS = "-j4";
    NIXPKGS_ALLOW_UNFREE = 1;
    NIX_REMOTE = "daemon";
    XDG_DATA_DIRS = "$HOME/.nix-profile/share:/nix/var/nix/profiles/default/share:$XDG_DATA_DIRS";
    RIP = "/srv/rick/ripped.audio";
    UP = "/mnt/linuxisos/seeds/upload";
    MUS = "/vroom/media/music";
    SEED = "/mnt/linuxisos/seeds";
  };

}
