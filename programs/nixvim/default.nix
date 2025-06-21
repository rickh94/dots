{ config, lib, ... }:
let
  helpers = config.lib.nixvim;
  setlocal_frompattern = [
    { pattern = [ "*.py" ]; tabstop = "4"; expandtab = true; }
    # "*.c" = { ts = 8; expandtab = false; };
    # "*.ino" = { ts = 8; expandtab = false; };
    # "*.ly" = { ts = 2; expandtab = false; };
    # "*.sql" = { ts = 4; expandtab = true; };
  ];

  setlocal_cmd = ts: et: ''setlocal tabstop = ${ts} shiftwidth = ${ts} '' + (if et then "expandtab" else "noexpandtab");
in
{
  programs.nixvim = {
    enable = true;
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    clipboard.register = "unnamedplus";
    opts = {
      tabstop = 2;
      expandtab = true;
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

      # diagnostics
      {
        action = helpers.utils.mkRaw "vim.diagnostic.goto_prev";
        key = "]d";
        mode = [ "n" ];
      }
      {
        action = helpers.utils.mkRaw "vim.diagnostic.goto_next";
        key = "[d";
        mode = [ "n" ];
      }

      # rebinds
      { action = "<C-d>zz"; key = "<C-d>"; mode = [ "n" ]; }
      { action = "<C-u>zz"; key = "<C-u>"; mode = [ "n" ]; }
      { action = "nzzzv"; key = "n"; mode = [ "n" ]; }
      { action = "Nzzzv"; key = "N"; mode = [ "n" ]; }

      # paste over selection without losing register
      { action = ''"_dP''; key = "<leader>p"; mode = [ "x" ]; }

      # system copy paste
      { action = ''"+y''; key = "<leader>y"; mode = [ "n" "v" ]; }
      { action = ''"+Y''; key = "<leader>Y"; mode = [ "n" "v" ]; }
      { action = ''"+p''; key = "<leader>P"; mode = [ "n" "v" ]; }

      # visual mode keybinds
      { action = ">gv"; key = ">"; mode = [ "v" ]; }
      { action = "<gv"; key = "<"; mode = [ "v" ]; }
    ];

    autoCmd = [

      {
        callback = {
          __raw = ''function()
            vim.opt_local.linebreak = true
            vim.opt_local.textwidth = 88
            vim.opt_local.spell = true
            vim.opt_local.spelllang = 'en_us'
          end'';
        };
        event = [
          "FileType"
        ];
        pattern = [
          "markdown"
        ];
      }

    ] ++ builtins.map
      (a: {
        pattern = a.pattern;
        event = [ "BufReadPre" "BufRead" ];
        command = setlocal_cmd a.tabstop a.expandtab;
      })
      setlocal_frompattern;

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



