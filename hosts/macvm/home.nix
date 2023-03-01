{ lib, config, pkgs, nixpkgs, ... }:
{
  imports = [
    ../_common/minimal.nix
    ../_common/mac/home-activation.nix
  ];

  home.stateVersion = "22.11";
  nixpkgs.config.allowUnfree = true;

}
