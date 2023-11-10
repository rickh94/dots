{ pkgs, inputs, system, ... }:
{
  xdg.configFile."nvim/init.lua" = {
    source = ./neovim/init.lua;
  };

  # xdg.configFile."nvim-astro" = {
  #   source = builtins.fetchGit {
  #     url = "https://github.com/astronvim/astronvim";
  #   };
  #   recursive = true;
  #   target = "nvim-astro";
  # };
  #
  # xdg.configFile."nvim-doom" = {
  #   source = builtins.fetchGit {
  #     url = "https://github.com/doom-neovim/doom-nvim";
  #   };
  #   recursive = true;
  # };
  #
  # xdg.configFile."nvim-nvchad" = {
  #   source = builtins.fetchGit {
  #     url = "https://github.com/NvChad/NvChad";
  #   };
  #   recursive = true;
  # };
  #
  # xdg.configFile."nvim-lunar" = {
  #   source = builtins.fetchGit {
  #     url = "https://github.com/LunarVim/LunarVim";
  #   };
  #   recursive = true;
  # };
  #
  #
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
}
