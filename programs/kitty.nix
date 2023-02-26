{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    font = {
      package = pkgs.nerdfonts;
      name = "CaskaydiaCove Nerd Font";
      size = 12;
    };
    theme = "Monokai Soda";
    settings = {
      shell = "${pkgs.nushell}/bin/nu";
    };
  };
}
