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
      shell = "zsh -c \"${pkgs.nushell}/bin/nu\"";
    };
    theme = "Monokai Soda";
  };

  xdg.configFile."kitty/startup.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      ${pkgs.bash}/bin/bash -c '${pkgs.nushell}/bin/nu'
    '';
  };
}
