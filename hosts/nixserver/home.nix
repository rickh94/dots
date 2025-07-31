{
  config,
  lib,
  pkgs,
  nixvim,
  ...
}: {
  imports = [
    nixvim.homeManagerModules.nixvim
    ../_common/minimal.nix
    ../_common/linux/minimal.nix
    ../../programs/nixvim
    ../../programs/direnv/default.nix
    ../../programs/atuin.nix
    #    ../../programs/hishtory.nix
    ../../programs/atuin.nix
  ];
  home.username = "rick";
  home.homeDirectory = "/home/rick";
  home.sessionVariables = {
    EDITOR = "hx";
    NIXPKGS_ALLOW_UNFREE = 1;
    NIX_REMOTE = "daemon";
    XDG_DATA_DIRS = "$HOME/.nix-profile/share:/nix/var/nix/profiles/default/share:$XDG_DATA_DIRS";
    RIP = "/srv/rick/ripped.audio";
    UP = "/mnt/linuxisos/seeds/upload";
    MUS = "/vroom/media/music";
    SEED = "/mnt/linuxisos/seeds";
  };

  home.packages = [
    pkgs.fswatch
    pkgs.entr
    pkgs.rubik
    pkgs.emacs
    pkgs.python312Packages.pipx
    pkgs.jpegoptim
    pkgs.oxipng
  ];
}
