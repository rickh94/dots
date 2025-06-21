{ config, ... }:
let
  helpers = config.lib.nixvim;
in
{
  programs.nixvim = {
    enable = true;
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };
    opts = {
      hlsearch = false;
      incsearch = true;
      number = true;
      relativenumber = true;
      mouse = "nv";
      breakindent = true;
      undofile = true;
      ignorecase = true;
      smartcase = true;
      updatetime = 50;
      timeout = true;
      timeoutlen = 300;
      completeopt = "menuone,noselect";
      termguicolors = true;
      swapfile = false;
      backup = false;
      undodir = helpers.utils.mkRaw "vim.fn.stdpath('state').. '/undodir'";
      smartindent = true;
      scrolloff = 8;
      wrap = false;
      cursorline = true;
    };

    keymaps = [
      { action = "<Nop>"; key = "<Space>"; options = { silent = true; }; mode = [ "n" "v" ]; }
      # save
      { action = "<cmd>w<cr>"; key = "<leader>w"; mode = [ "n" ]; }
      #diagnostics
      {
        action = helpers.utils.mkRaw "vim.diagnostic.goto_prev";
        key = "]d";
        mode = [ "n" ];
      }
    ];
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "macchiato";
      };
    };

    plugins = {
      lualine.enable = true;
    };
  };
}



