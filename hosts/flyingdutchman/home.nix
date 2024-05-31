{ config
, lib
, pkgs
, inputs
, ...
}: {
  imports = [
    ../_common/default.nix
    ../_common/linux/desktop.nix
    ../../programs/neovim/basic.nix
  ];
  home.username = "daveyjones";
  home.homeDirectory = "/home/daveyjones";

  programs.bash = {
    bashrcExtra = ''
      source /etc/profile.d/nix-env.sh
    '';
  };

  programs.zsh.profileExtra = ''
    source /etc/profile.d/nix-env.sh
  '';

  programs.fish.shellInit = ''
    source /etc/profile.d/nix-env.sh
  '';

  xsession.profileExtra = ''
    source /etc/profile.d/nix-env.sh
  '';

  xdg.enable = true;

  home.packages = [
    pkgs.glibc
    pkgs.xdotool
    pkgs.feh
    pkgs.xorg.xmodmap
    pkgs.xorg.setxkbmap
    inputs.codeium.packages.x86_64-linux.codeium-lsp
  ];

  systemd.user.startServices = true;
}
