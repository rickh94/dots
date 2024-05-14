{ lib
, config
, pkgs
, nixpkgs
, ...
}: {
  imports = [
    ../_common/desktop.nix
    ../_common/mac/home-activation.nix
    ../../programs/wezterm-mac.nix
    ../../programs/neovim/full-default.nix
  ];

  home.stateVersion = "22.11";
  nixpkgs.config.allowUnfree = true;

  home.file.".local/state/redis/.keep" = {
    enable = true;
    text = "";
  };

  home.packages = [
    pkgs.fswatch
    pkgs.entr
    pkgs.rubik
    pkgs.emacs
  ];

}
