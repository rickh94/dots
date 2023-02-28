{ lib, config, pkgs, nixpkgs, ... }:
{
  imports = [
    ../common.nix
    ../../services/yabairc.nix
    ../../services/skhdrc.nix
    ../../programs/hammerspoon.nix
  ];

  home.stateVersion = "22.11";
  nixpkgs.config.allowUnfree = true;


  home.activation = lib.mkAfter {
    copyApplications =
      let
        apps = pkgs.buildEnv {
          name = "home-manager-applications";
          paths = config.home.packages;
          pathsToLink = "/Applications";
        };
      in
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        echo "Setting up $HOME/Applications/HMApps..."
        baseDir=$HOME/Applications/HMApps
        if [ -d "$baseDir" ]; then
          rm -rf "$baseDir"
        fi
        mkdir -p "$baseDir"
        for appFile in ${apps}/Applications/*; do
          echo "Linkg $appFile"
          src="$(/usr/bin/stat -f%Y "$appFile")"
          appname="$(basename "$src")"
          /usr/bin/osascript -e "tell app \"Finder\" to make alias file at POSIX file \"$baseDir\" to POSIX file \"$src\" with properties {name: \"$appname\"}";
        done
      '';
  };

  programs.nushell.extraEnv = ''
    let-env PATH = ($env.PATH | append "/opt/homebrew/bin")
  '';

  programs.fish.interactiveShellInit = ''
    fish_add_path "/opt/homebrew/bin"
  '';
}
