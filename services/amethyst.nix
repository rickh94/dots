{ pkgs, ... }:
{
  xdg.configFile."amethyst/amethyst.yml".source = (pkgs.formats.yaml { }).generate "something" {
    mod1 = [ "option" "shift" ];
    mod2 = [ "option" "shift" "control" "command" ];
    "focus-follows-mouse" = true;
    "mouse-swaps-windows" = true;
    "mouse-resizes-windows" = true;
    "toggle-float" = {
      mod = "mod2";
      key = "f";
    };
    "floating" = [
      "System Settings"
    ];
  };

  xdg.configFile."skhd/skhdrc" = {
    executable = true;
    text = ''
      #!/usr/bin/env sh
      hyper - return : alacritty msg create-window
    '';
  };
}
