{ pkgs, config, ... }:
{
  xdg.configFile."skhd/skhdrc" = {
    executable = true;
    text = ''
      #!/usr/bin/env sh
      #  Quickly reload yabai
      ctrl + alt + cmd - r : launchctl kickstart -k "gui/$UID/com.koekeishiya.yabai"

      # switch to space
      ctrl - 1 : yabai -m space --focus 1
      ctrl - 2 : yabai -m space --focus 2
      ctrl - 3 : yabai -m space --focus 3
      ctrl - 4 : yabai -m space --focus 4
      ctrl - 5 : yabai -m space --focus 5
      ctrl - 6 : yabai -m space --focus 6
      ctrl - 7 : yabai -m space --focus 7
      ctrl - 8 : yabai -m space --focus 8
      ctrl - 9 : yabai -m space --focus 9

      # send window to space
      hyper - 1 : yabai -m window --space 1
      hyper - 2 : yabai -m window --space 2
      hyper - 3 : yabai -m window --space 3
      hyper - 4 : yabai -m window --space 4
      hyper - 5 : yabai -m window --space 5
      hyper - 6 : yabai -m window --space 6
      hyper - 7 : yabai -m window --space 7
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

      # show/hide alacritty dropdown terminal
      # hyper - return : ${config.home.homeDirectory}/.config/skhd/scripts/toggle-alacritty.sh
      hyper - return : alacritty msg create-window
    '';
  };

  # xdg.configFile."skhd/scripts/toggle-alacritty.sh" = {
  #   executable = true;
  #   text = ''
  #     #!/usr/bin/env bash
  #     # get alacritty's id from yabai
  #     aid=`yabai -m query --windows | ${pkgs.jq}/bin/jq '.[] |select(.app == "Alacritty").id' | tr -d '\n'`
  #
  #     # if the id is empty, open alacritty
  #     if [[ -z $aid ]]; then
  #       /usr/bin/open -a ${config.home.homeDirectory}/Applications/HMApps/Alacritty.app  
  #       sleep 1;
  #       aid=`yabai -m query --windows | ${pkgs.jq}/bin/jq '.[] |select(.app == "Alacritty").id' | tr -d '\n'`
  #       #yabai -m window $aid --resize abs:1600:300 
  #       #sleep 0.5;
  #       #yabai -m window $aid --move abs:0:0 
  #       #sleep 0.5;
  #       yabai -m window $aid --focus
  #       exit 0;
  #     fi
  #
  #     is_visible=`yabai -m query --windows --window $aid | ${pkgs.jq}/bin/jq '."is-visible"'`
  #
  #     if [ $is_visible == 'true' ]; then
  #       /usr/bin/osascript -e "
  #     tell app \"System Events\"
  #       set visible of process \"Alacritty\" to false
  #     end tell"
  #     else
  #       #yabai -m window $aid --resize abs:1600:300 
  #       #yabai -m window $aid --move abs:0:0 
  #       yabai -m window $aid --focus
  #     fi
  #   '';
  # };
}
