{ pkgs, ... }:
{
  programs.direnv = {
    enable = true;
  };

  xdg.configFile."direnv/lib" = {
    source = ./lib;
    recursive = true;
  };
}
