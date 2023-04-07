{ ... }:
{
  xdg.configFile."yabai/yabairc" = {
    executable = true;
    text = ''
      #!/usr/bin/env sh
      yabai -m signal --add event=dock_did_restart action="sudo /opt/homebrew/bin/yabai --load-sa"
      sudo /opt/homebrew/bin/yabai --load-sa

      function setup_space {
        local idx="$1"
        local name="$2"
        local space=
        echo "setup space $idx : $name"

        space=$(yabai -m query --spaces --space "$idx")
        if [ -z "$space" ]; then
          yabai -m space --create
        fi

        yabai -m space "$idx" --label "$name"
      }

      ########## GLOBAL CONFIGURATION SETTINGS ##########

      yabai -m config focus_follows_mouse autofocus
      yabai -m config layout bsp
      yabai -m config split_ratio 0.6
      yabai -m config mouse_modifier ctrl
      yabai -m config mouse_action1 move
      yabai -m config mouse_action2 resize
      yabai -m config window_border on
      yabai -m config window_border_width 4
      yabai -m config active_window_border_color 0xee80c080
      yabai -m config window_placement second_child
      yabai -m config window_opacity off
      yabai -m config window_opacity_duration 0.0
      yabai -m config active_window_opacity 1.0
      yabai -m config window_border_blur off
      yabai -m config window_animation_duration 0.0


      ##########         SPACE NAMES            ##########

      setup_space 1 one
      setup_space 2 two
      setup_space 3 three
      setup_space 4 four
      setup_space 5 five
      setup_space 6 six
      setup_space 7 seven

      ##########     SPACE WINDOW CONSTRAINTS      ##########
      yabai -m rules --add app="Alacritty" manage=on

      ##########     FLOATING WINDOW SETTINGS      ##########

      yabai -m rule --add app="Finder" sticky=on layer=above manage=off
      yabai -m rule --add app="Obsidian" sticky=on layer=above manage=off
      yabai -m rule --add app="System Settings" sticky=on manage=off
      yabai -m rule --add app="Karabiner-Elements" sticky=on layer=above manage=off
      yabai -m rule --add app="Karabiner-EventViewer" sticky=on layer=above manage=off
      yabai -m rule --add app="System Information" sticky=off layer=above manage=off
      yabai -m rule --add app="Warp" sticky=off layer=above manage=off
      yabai -m rule --add app="iTerm 2" sticky=off layer=above manage=off
      yabai -m rule --add app="Terminal" sticky=off layer=above manage=off
      yabai -m rule --add app="Notable" sticky=on layer=above manage=off
      yabai -m rule --add app="Notes" sticky=on layer=above manage=off
      yabai -m rule --add app="Bitwarden" sticky=on manage=off
      yabai -m rule --add app="Arq 7" sticky=on manage=off
    '';
  };
}
