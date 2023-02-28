{ config, pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        decorations = "none";
        opacity = 0.9;
      };

      font = {
        normal = {
          family = "CaskaydiaCove Nerd Font Mono";
          style = "Regular";
        };
        bold = {
          family = "CaskaydiaCove Nerd Font Mono";
          style = "Bold";
        };
        italic = {
          family = "CaskaydiaCove Nerd Font Mono";
          style = "Italic";
        };
        bold_italic = {
          family = "CaskaydiaCove Nerd Font Mono";
          style = "Bold Italic";
        };
        size = 12.0;
      };

      shell = {
        program = "${pkgs.nushell}/bin/nu";
        args = [
          "-c"
          "${pkgs.zellij}/bin/zellij"
        ];
      };
    };
  };
}
