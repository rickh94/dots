{ lib, config, pkgs, nixpkgs, ... }:
{
  imports = [
    ../_common/default.nix
    ../_common/mac/home-activation.nix
    ../../services/yabairc.nix
    ../../services/skhdrc.nix
  ];

  home.stateVersion = "22.11";
  nixpkgs.config.allowUnfree = true;

  programs.alacritty.settings.window = {
    position = {
      x = 0;
      y = 0;
    };

    dimensions = {
      columns = 233;
      lines = 22;
    };
  };



  /* programs.nushell.extraEnv = ''
    let-env PATH = ($env.PATH | append "/opt/homebrew/bin")
    '';

    programs.fish.interactiveShellInit = ''
    fish_add_path "/opt/homebrew/bin"
    ''; */
}
