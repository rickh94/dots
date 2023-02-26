{ pkgs, ...}:
{
    programs.zellij.enable = true;

    xdg.configFile."zellij/config.kdl" = {
      text = ''
      default_shell "${pkgs.nushell}/bin/nu"
      theme "catppuccin-mocha"
      '';
    };
  }
