{ pkgs, ... }: {
  imports = [
    ../../programs/nixvim
    ../../programs/ghostty-linux.nix
    ../_common/minimal.nix
    ../../programs/direnv/default.nix
    ../../programs/tmux.nix
    ../../programs/atuin.nix
  ];
  home.stateVersion = "22.11";
  home.username = "rick";
  home.homeDirectory = "/home/rick";

  home.packages = with pkgs; [
    feh
  ];

  programs.home-manager.enable = true;
}
