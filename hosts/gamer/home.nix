{ pkgs, ... }: {
  imports = [
    ../_common/desktop.nix
    ../../programs/nixvim
    ../../programs/ghostty-linux.nix
    ../_common/minimal.nix
    ../_common/linux/configuration/plasma.nix
  ];
  home.stateVersion = "22.11";
  home.username = "rick";
  home.homeDirectory = "/home/rick";

  home.packages = with pkgs; [
    glibc
    feh
    steam
    nvtopPackages.nvidia
    rclone
    freecad
    openscad-unstable
    bs-manager
    bitwarden-desktop
  ];

  programs.home-manager.enable = true;

  # systemd.user.startServices = true;

  # xdg.configFile."wivrn/config.json" = {
  #   text = ''
  #     {
  #       "bitrate": 100000000,
  #       "debug-gui": false,
  #       "encoders": [
  #         {
  #           "codec": "h264",
  #           "encoder": "nvenc",
  #           "height": 1.0,
  #           "offset_x": 0.0,
  #           "offset_y": 0.0,
  #           "width": 1.0
  #         }
  #       ],
  #       "use-steamvr-lh": false
  #     }
  #   '';
  # };
}
