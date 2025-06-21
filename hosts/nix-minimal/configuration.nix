{ pkgs
, ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../_common/linux/configuration/basic.nix
    ../_common/linux/configuration/xconfig-noi3.nix
    ../_common/rick-passwordless-sudo.nix
  ];

  networking.hostName = "nix-minimal";
  networking.hostId = "99a4b733";
  users.users.rick.shell = pkgs.zsh;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.tmp.tmpfsSize = "8G";
  boot.kernelParams = [ "nohibernate" ];

  users.mutableUsers = true;
  users.users = {
    rick = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "libvirtd" "disk" "cdrom" "docker" ];
      uid = 1000;
    };
  };

  environment.systemPackages = with pkgs; [
    firefox
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
    plymouth
  ];
  programs.zsh.enable = true;

  environment.pathsToLink = [ "/libexec" ];

  nix.optimise.automatic = true;
}
