{ lib, config, pkgs, nixpkgs, ... }:
{
  imports = [
    ../_common/desktop.nix
    ../_common/mac/home-activation.nix
    # ../../services/yabairc.nix
    # ../../services/skhdrc.nix
    # ../../services/sketchybar.nix
    ../../services/amethyst.nix
    ../../programs/wezterm-mac.nix
  ];

  home.stateVersion = "22.11";
  nixpkgs.config.allowUnfree = true;


  home.file.".local/state/redis/.keep" = {
    enable = true;
    text = "";
  };



  /* programs.nushell.extraEnv = ''
    let-env PATH = ($env.PATH | append "/opt/homebrew/bin")
    '';

    programs.fish.interactiveShellInit = ''
    fish_add_path "/opt/homebrew/bin"
    ''; */
}
