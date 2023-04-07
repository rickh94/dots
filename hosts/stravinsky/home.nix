{ lib, config, pkgs, nixpkgs, ... }:
{
  imports = [
    ../_common/default.nix
    ../_common/mac/home-activation.nix
    ../../services/yabairc.nix
    ../../services/skhdrc.nix
    ../../services/sketchybar.nix
  ];

  home.stateVersion = "22.11";
  nixpkgs.config.allowUnfree = true;

  programs.alacritty.settings.window = {
    dimensions = {
      columns = 500;
      lines = 500;
    };
  };

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
