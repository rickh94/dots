{ pkgs, ... }:
{
  services.sxhkd = {
    enable = true;
    keybindings = {
      # reload sxhkd
      "super + Escape" = "pkill -USR1 -x sxhkd";

      "super + @Space" = "${pkgs.rofi}/bin/rofi -show run";

      # terminal
      "hyper + t" = "kitty";
      # drop down terminal
      "hyper + Return" = "${pkgs.tdrop}/bin/tdrop -ma -y 32 -w -4 -h 35% alacritty";

      # bspwm hotkeys
      # quit/restart
      "super + alt + {q,r}" = "bspc {quit,wm -r}";

      # close/kill
      "super + {_,shift + }w" = "bspc node -{c,k}";

      # state/flags
      "super + {t,shift +t,s,f}" = "bspc node -t {tile,pseudo_tiled,floating,fullscreen}";

      # set the node flags
      "super + ctrl + {m,x,y,z}" = "bspc node -g {marked,locked,sticky,private}";

      # focus/swap

      # focus the node in the given direction
      "hyper + {h,j,k,l}" = "bspc node -f {west,south,north,east}";

      # swap the node in the given direction
      "ctrl + alt + {h,j,k,l}" = "bspc node -s {west,south,north,ease}";

      # focus the next/previous window in the current desktop
      "super + {_,shift + } c" = "bspc node -f {next,prev}.local.!hidden.window";

      # focus the given desktop
      "ctrl + {1-9,0}" = "bspc desktop -f '^{1-9,10}'";

      # send node to the given desktop
      "hyper + {1-9,0}" = "bspc node -d '^{1-9,10}'";

      # move/resize

      # expand a window by moving one of its sides outward
      "super + alt + {h,j,k,l}" = "bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}";

      # contract a window by moving one of its sides inward
      "super + alt + shift + {h,j,k,l}" = "bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}";

      # move a floating window
      "super + {Left,Down,Up,Right}" = "bspc node -v {-20 0,0 20,0 -20,20 0}";
    };
  };
}
