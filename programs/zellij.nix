{ pkgs, ... }:
{
  programs.zellij.enable = true;

  xdg.configFile."zellij/config.kdl" = {
    text = ''
      default_shell "${pkgs.fish}/bin/fish"
      theme "catppuccin-mocha"
    '';
  };
}
