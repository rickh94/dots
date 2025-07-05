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
    feishin
  ];

  programs.home-manager.enable = true;

  xdg.configFile."openvr/openvrpaths.vrpath".text = ''
    {
      "config": [
        "~/.local/share/Steam/config"
      ],
      "external_drivers": null,
      "jsonid": "vrpathreg",
      "log": [
        "~/.local/share/Steam/logs"
      ],
      "runtime": [
        "${pkgs.opencomposite}/lib/opencomposite"
      ],
      "version": 1
    }
  '';
}
