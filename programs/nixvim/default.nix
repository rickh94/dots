{ ... }:
{
  programs.nixvim = {
    enable = true;
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };
    options.hlsearch = false;
    # config = {
    #   opts = {
    #     hlsearch = false;
    #     incsearch = true;
    #     number = true;
    #     relativenumber = true;
    #     mouse = "nv";
    #     breakindent = true;
    #     undofile = true;
    #     ignorecase = true;
    #     smartcase = true;
    #     updatetime = 50;
    #     timeout = true;
    #     timeoutlen = 300;
    #     completeopt = "menuone,noselect";
    #     termguicolors = true;
    #     swapfile = false;
    #     backup = false;
    #     undodir = "vim.fn.stdpath('state') .. '/undodir'";
    #     smartindent = true;
    #     scrolloff = 8;
    #     wrap = false;
    #     cursorline = true;
    #   };
    #
    # };

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



