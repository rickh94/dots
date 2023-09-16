{ pkgs, inputs, system, ... }:
{
  xdg.configFile."nvim/init.lua" = {
    source = ./neovim/init.lua;
  };

  xdg.configFile."nvim-astro" = {
    source = ./neovim/nvim-astronvim;
    recursive = true;
    target = "nvim-astro";
  };

  xdg.configFile."nvim-doom" = {
    source = ./neovim/nvim-doom;
    recursive = true;
  };

  xdg.configFile."nvim-nvchad" = {
    source = ./neovim/nvim-nvchad;
    recursive = true;
  };

  xdg.configFile."nvim-lunar" = {
    source = ./neovim/nvim-lunarvim;
    recursive = true;
  };


  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
}
