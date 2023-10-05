{ pkgs, ... }:
{
  xdg.configFile."amethyst/amethyst.yml".source = (pkgs.formats.yaml { }).generate "something" {
    mod1 = [ "control" ];
    mod2 = [ "option" "shift" "control" "command" ];
    "focus-follows-mouse" = true;
    "mouse-swaps-windows" = true;
    "mouse-resizes-windows" = true;
    "toggle-float" = {
      mod = "mod1";
      key = "f";
    };
  };
}
