{ ... }:
{
  xdg.configFile."skhd/skhdrc" = {
    executable = true;
    text = ''
      !/usr/bin/env sh
      #  Quickly reload yabai
      ctrl + alt + cmd - r : launchctl kickstart -k "gui/$UID/homebrew.mxcl.yabai"

      # switch to space
      ctrl - 1 : yabai -m space --focus www
      ctrl - 2 : yabai -m space --focus dev
      ctrl - 3 : yabai -m space --focus entertainment
      ctrl - 4 : yabai -m space --focus music
      ctrl - 5 : yabai -m space --focus remote
      ctrl - 6 : yabai -m space --focus six
      ctrl - 7 : yabai -m space --focus seven
      ctrl - 8 : yabai -m space --focus 8
      ctrl - 9 : yabai -m space --focus 9

      # send window to space
      hyper - 1 : yabai -m window --space www
      hyper - 2 : yabai -m window --space dev
      hyper - 3 : yabai -m window --space entertainment
      hyper - 4 : yabai -m window --space music
      hyper - 5 : yabai -m window --space remote
      hyper - 6 : yabai -m window --space six
      hyper - 7 : yabai -m window --space seven
      hyper - 8 : yabai -m window --space 8
      hyper - 9 : yabai -m window --space 9

      # focus window direction
      hyper - h : yabai -m window --focus west
      hyper - j : yabai -m window --focus south
      hyper - k : yabai -m window --focus east
      hyper - l : yabai -m window --focus north

      # swap window in direction
      ctrl + alt - h : yabai -m window --swap west
      ctrl + alt - j : yabai -m window --swap south
      ctrl + alt - k : yabai -m window --swap east
      ctrl + alt - l : yabai -m window --swap north

      # swap window with first
      hyper - space : yabai -m window --swap first

      # change whether or not a window is floating
      hyper - f : yabai -m window --toggle float

      # change whether or not a window is shown on all spaces
      hyper - s : yabai -m window --toggle sticky

      # rotate window tree clockwise
      hyper - 0x21 : yabai -m space --rotate 90
      hyper - 0x1E : yabai -m space --mirror y-axis
    '';
  };
}
