{ pkgs
, nixvim
, devenv
, ...
}:
let
  bacon-config = import ../../programs/bacon-config.nix { };
  bacon-text = bacon-config.text;
in
{
  imports = [
    nixvim.homeManagerModules.nixvim
    ../_common/desktop.nix
    ../_common/mac/home-activation.nix
    ../../programs/wezterm-mac.nix
    ../../programs/ghostty-mac.nix
    ../../programs/nixvim
  ];

  home.stateVersion = "22.11";
  nixpkgs.config.allowUnfree = true;

  home.file.".local/state/redis/.keep" = {
    enable = true;
    text = "";
  };

  home.file."Library/Application Support/org.dystroy.bacon/prefs.toml".text = bacon-text;

  home.packages = [
    pkgs.fswatch
    pkgs.entr
    pkgs.rubik
    pkgs.emacs
    pkgs.python313Packages.pipx
    devenv.packages.${pkgs.system}.devenv
  ];
}
