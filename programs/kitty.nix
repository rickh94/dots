{ pkgs, config, ... }:
{
  programs.kitty = {
    enable = true;
    # font = {
    #   package = pkgs.nerdfonts;
    #   name = "VictorMono Nerd Font Mono";
    #   size = 13.0;
    # };
    settings = {
      shell = "${pkgs.fish}/bin/fish";
      cursor_shape = "beam";
      background_opacity = "0.95";
      hide_window_decorations = "yes";
      bold_font = "Hack Nerd Font Mono Bold";
      italic_font = "Hack Nerd Font Mono Italic";
      bold_italic_font = "Hack Nerd Font Mono Bold Italic";
    };
    # theme = "Molokai";
  };

  xdg.configFile."kitty/startup.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      ${pkgs.bash}/bin/bash -c '${pkgs.fish}/bin/fish'
    '';
  };
}
