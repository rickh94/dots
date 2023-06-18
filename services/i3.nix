{ pkgs, lib, ... }:
let
  mod = "Mod4";
  hyper = "Mod3";
  refresh_i3status = "killall -SIGUSR1 i3status";
in
{
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      floating.modifier = mod;
      menu = "rofi -show run";
      startup = [
        { command = "${pkgs.dex}/bin/dex --autostart --environment i3"; }
        { command = "${pkgs.xss-lock}/bin/xss-lock --transfer-sleep-lock -- i3lock --nofork"; }
        # { command = "nm-applet"; }
        { command = "${pkgs.feh}/bin/feh --bg-fill --randomize $HOME/Wallpapers/*.png"; }
        # { command = "xmodmap -e 'keycode 66 = Hyper_L'"; }
        # { command = "xmodmap -e 'clear Lock'"; }
        # { command = "xmodmap -e 'remove Mod4 = Hyper_L'"; }
        # { command = "xmodmap -e 'add Mod3 = Hyper_L'"; }
        # { command = "${pkgs.xorg.setxkbmap}/bin/setxkbmap -option shift:both_capslock"; }
      ];
      fonts = {
        names = [ "DejaVu Sans Mono" ];
        style = "Bold Semi-Condensed";
        size = 10.0;
      };
      keybindings = {
        "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +10% && ${refresh_i3status}";
        "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -10% && ${refresh_i3status}";
        "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle && ${refresh_i3status}";

        "${mod}+Return" = "exec alacritty";
        "${mod}+Shift+q" = "kill";
        "${mod}+space" = "exec --no-startup-id rofi -show run";

        "${mod}+h" = "focus left";
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+l" = "focus right";
        "${mod}+Left" = "focus left";
        "${mod}+Down" = "focus down";
        "${mod}+Up" = "focus up";
        "${mod}+Right" = "focus right";

        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+j" = "move down";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+l" = "move right";
        "${mod}+Shift+Left" = "move left";
        "${mod}+Shift+Down" = "move down";
        "${mod}+Shift+Up" = "move up";
        "${mod}+Shift+Right" = "move right";

        "${mod}+s" = "split h";
        "${mod}+v" = "split v";
        "${mod}+F11" = "fullscreen toggle";
        "${mod}+w" = "layout tabbed";
        "${mod}+e" = "layout toggle split";
        "${mod}+f" = "floating toggle";
        "${mod}+Shift+f" = "focus mode_toggle";
        "${mod}+a" = "focus parent";

        "${mod}+1" = "workspace number 1";
        "${mod}+2" = "workspace number 2";
        "${mod}+3" = "workspace number 3";
        "${mod}+4" = "workspace number 4";
        "${mod}+5" = "workspace number 5";
        "${mod}+6" = "workspace number 6";
        "${mod}+7" = "workspace number 7";
        "${mod}+8" = "workspace number 8";
        "${mod}+9" = "workspace number 9";

        "${mod}+Shift+1" = "move container to workspace number 1";
        "${mod}+Shift+2" = "move container to workspace number 2";
        "${mod}+Shift+3" = "move container to workspace number 3";
        "${mod}+Shift+4" = "move container to workspace number 4";
        "${mod}+Shift+5" = "move container to workspace number 5";
        "${mod}+Shift+6" = "move container to workspace number 6";
        "${mod}+Shift+7" = "move container to workspace number 7";
        "${mod}+Shift+8" = "move container to workspace number 8";
        "${mod}+Shift+9" = "move container to workspace number 9";

        "${mod}+Shift+c" = "reload";
        "${mod}+Shift+r" = "restart";
        "${mod}+Shift+e" = "exec \"i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' 'i3-msg exit'\"";

        "${mod}+r" = "mode \"resize\"";
      };
      bars = [
        {
          position = "bottom";
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-bottom.toml";
        }
      ];
    };
    extraConfig = ''
      mode "resize" {
        bindsym h resize shrink width 10 px or 10 ppt
            bindsym j resize grow height 10 px or 10 ppt
            bindsym k resize shrink height 10 px or 10 ppt
            bindsym l resize grow width 10 px or 10 ppt

            bindsym Left resize shrink width 10 px or 10 ppt
            bindsym Down resize grow height 10 px or 10 ppt
            bindsym Up resize shrink height 10 px or 10 ppt
            bindsym Right resize grow width 10 px or 10 ppt

            bindsym Return mode "default"
            bindsym Escape mode "default"
            bindsym ${mod}+r mode "default"
      }
    '';
  };

  programs.i3status-rust = {
    enable = true;
    bars = {
      bottom = {
        icons = "awesome6";
        blocks = [
          {
            block = "disk_space";
            path = "/";
            info_type = "available";
            interval = 60;
            warning = 20.0;
            alert = 10;
          }
          {
            block = "memory";
          }
          {
            block = "cpu";
            interval = 1;
          }
          {
            block = "load";
            interval = 1;
          }
          {
            block = "sound";
          }
          {
            block = "time";
            interval = 5;
          }
        ];
      };
    };
  };

}

