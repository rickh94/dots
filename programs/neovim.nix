{ pkgs, ... }:
{
  xdg.configFile.nvim = {
    source = ./neovim;
  };
}
