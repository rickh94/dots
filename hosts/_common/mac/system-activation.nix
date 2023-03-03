{ pkgs, lib, ... }:
let
  me = "rick";
in
{
  system.activationScripts.applications.text = pkgs.lib.mkForce ''
    echo "setting up ~/Applications/NixApps.."
    mkdir -p ~/Applications
    chown ${me} ~/Applications
    rm -rf ~/Applications/NixApps
    mkdir -p ~/Applications/NixApps
    chown ${me} ~/Applications/NixApps
    find ${config.system.build.applications}/Applications -maxdepth 1 -type l | while read f; do
      echo "Linking $f"
      src=$(/usr/bin/stat -f%Y "$f")
      appname="$(basename "$f")"
      /usr/bin/osascript -e "tell app \"Finder\" to make alias file at POSIX file \"/Users/${me}/Applications/NixApps/\" to POSIX file \"$src\" with properties {name: \"$appname\"}";
    done
  '';

}
