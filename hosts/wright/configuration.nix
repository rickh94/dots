{ config
, pkgs
, lib
, chosenfonts
, ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../_common/linux/configuration/boot.nix
    ../_common/linux/configuration/basic.nix
    ../_common/linux/configuration/xconfig-noi3.nix
    ../_common/linux/configuration/podman.nix
    ../_common/linux/configuration/impermanence.nix
    ../_common/linux/configuration/users-rick.nix
    ../_common/rick-passwordless-sudo.nix
  ];

  networking.hostName = "wright";
  networking.hostId = "aa31a972";
  users.users.rick.shell = pkgs.zsh;

  environment.systemPackages = with pkgs; [
    firefox
    (nerdfonts.override { fonts = chosenfonts; })
    neovim
    git
    alacritty
    xorg.xinit
    killall
    xdotool
    xorg.xwininfo
    lightdm-slick-greeter
    nushell
    wireguard-tools
    tree
    curl
    podman
    podman-compose
    zsh
    xfce.xfce4-whiskermenu-plugin
    vivaldi
  ];
  programs.zsh.enable = true;

  environment.pathsToLink = [ "/libexec" ];
  services.atd.enable = true;
  nix.optimise.automatic = true;
  # nix.settings = {
  #   substituters = [ "https://nix-gaming.cachix.org" ];
  #   trusted-public-keys = [ "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
  # };
}
