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
          family = "CaskaydiaCove NF";
          style = "Regular";
        };
        bold = {
          family = "CaskaydiaCove NF";
          style = "Bold";
        };
        italic = {
          family = "CaskaydiaCove NF";
          style = "Italic";
        };
        bold_italic = {
          family = "CaskaydiaCove NF";
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
