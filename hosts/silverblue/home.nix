{ pkgs, ... }: {
  imports = [
    ../../programs/nixvim
    ../../programs/ghostty-mac.nix
    ../_common/minimal.nix
    ../../programs/direnv/default.nix
    ../../programs/tmux.nix
    ../../programs/atuin.nix
  ];
  home.stateVersion = "22.11";
  home.username = "rick";
  home.homeDirectory = "/var/home/rick";

  programs.home-manager.enable = true;

  # programs.bash = {
  #   bashrcExtra = ''
  #     source /etc/profile.d/nix-daemon.sh
  #   '';
  # };
  #
  # programs.zsh.profileExtra = ''
  #   source /etc/profile.d/nix-daemon.sh
  # '';
  #
  # programs.fish.shellInit = ''
  #   source /etc/profile.d/nix-daemon.fish
  # '';
  #
  # xsession.profileExtra = ''
  #   source /etc/profile.d/nix-daemon.sh
  # '';
}
