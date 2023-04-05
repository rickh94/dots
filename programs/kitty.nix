{ pkgs, config, ... }:
{
  programs.kitty = {
    enable = true;
    font = {
      package = pkgs.nerdfonts;
      name = "VictorMono Nerd Font";
      size = 12;
    };
    settings = {
      shell = "${pkgs.fish}/bin/fish";
      cursor_shape = "beam";
    };
    theme = "Monokai Soda";
  };

  xdg.configFile."kitty/startup.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      ${pkgs.bash}/bin/bash -c '${pkgs.fish}/bin/fish'
    '';
  };
}
