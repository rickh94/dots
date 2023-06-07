{ config, pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        decorations = "none";
        opacity = 0.95;
        startup_mode = "Windowed";
      };
      cursor.style.shape = "Beam";
      cursor.style.blinking = "Off";

      font = {
        normal = {
          family = "VictorMono Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "VictorMono Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "VictorMono Nerd Font";
          style = "Italic";
        };
        bold_italic = {
          family = "VictorMono Nerd Font";
          style = "Bold Italic";
        };
        size = 13.0;
      };

      shell = {
        program = "${pkgs.zsh}/bin/zsh";
        args = [
          "-c"
          "${pkgs.zellij}/bin/zellij -l compact"
        ];
      };
    };
  };
}
