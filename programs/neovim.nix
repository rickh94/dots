{ pkgs, ... }:
{
  xdg.configFile."nvim/init.lua" = {
    source = ./neovim/init.lua;
  };
}
