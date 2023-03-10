{ pkgs, ... }:
{
  xsession.windowManager.bspwm = {
    enable = true;
    settings = {
      "border_width" = 2;
      "window_gap" = 4;
      "focus_follows_pointer" = true;
      "left_padding" = 0;
      "right_paddding" = 0;
      "top_padding" = 30;
      "normal_border_color" = "#949494";
      "active_border_color" = "#949494";
    };

    rules = {
      "Alacritty" = {
        state = "floating";
        stick = true;
      };
      "firefox" = {
        desktop = "^1";
      };
      "thunderbird" = {
        desktop = "^1";
      };
      "neovide" = {
        desktop = "^2";
      };
      "code" = {
        desktop = "^2";
      };
      "jetbrains-webstorm" = {
        desktop = "^2";
      };
      "jetbrains-pycharm" = {
        desktop = "^2";
      };
      "jetbrains-idea" = {
        desktop = "^2";
      };
      "Spotify" = {
        desktop = "^3";
      };
      "vlc" = {
        desktop = "^3";
      };
      "MuseScore4" = {
        desktop = "^4";
      };
    };

    startupPrograms = [
      "${pkgs.polybar}/bin/polybar"
    ];

    extraConfig = ''
      xrandr --output DP-4 --mode 3440x1440
      setxkbmap -layout us -option "shift:both_capslock_cancel,caps:hyper"
      ${pkgs.feh}/bin/feh --bg-fill --randomize $HOME/Wallpapers/*.png
    '';
  };
}
