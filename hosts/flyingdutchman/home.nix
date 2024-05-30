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
      source $HOME/.nix-profile/etc/profile.d/nix.sh
    '';
  };

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