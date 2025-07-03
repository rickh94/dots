{ pkgs, ... }: {
  imports = [
    ../_common/desktop.nix
    # ../_common/linux/desktop.nix
    ../../programs/nixvim
    ../../programs/ghostty-linux.nix
    ../_common/minimal.nix
  ];
  home.stateVersion = "22.11";
  home.username = "rick";
  home.homeDirectory = "/home/rick";

  home.packages = with pkgs; [
    glibc
    xdotool
    feh
    steam
    prismlauncher
    nvtopPackages.nvidia
    rclone
    freecad
    openscad-unstable
    bs-manager
  ];

  systemd.user.startServices = true;
  # xfconf.settings.xfce4-keyboard-shortcuts = {
  #   "commands/custom/&lt;Super&gt;space" =
  #     "${pkgs.rofi}/bin/rofi -show run";
  #   "commands/custom/&lt;Super" =
  #     "xfce-popup-whiskermenu";
  # };
}
