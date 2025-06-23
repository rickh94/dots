{ config, ... }:
let
  helpers = config.lib.nixvim;
  setlocal_frompattern = [
    { pattern = [ "*.py" "*.sql" ]; tabstop = "4"; expandtab = true; }
    { pattern = [ "*.c" "*.ino" ]; tabstop = "8"; expandtab = false; }
    { pattern = [ "*.ly" ]; tabstop = "2"; expandtab = false; }
    { pattern = [ "*.sql" ]; tabstop = "4"; expandtab = true; }
  ];

  setlocal_cmd = ts: et: ''setlocal tabstop=${ts} shiftwidth=${ts} '' + (if et then "expandtab" else "noexpandtab");

  filetypes = [
    { pattern = [ "*.njk" ]; ft = "twig"; }
    { pattern = [ "*.pss" ]; ft = "css"; }
    { pattern = [ "*.astro" ]; ft = "astro"; }
  ];
in
{
  imports = [
    ./lsp.nix
    ./plugins/treesitter.nix
    ./plugins/aerial.nix
    ./plugins/arrow.nix
    ./plugins/blink-cmp.nix
    ./plugins/conform.nix
    ./plugins/indent-blankline.nix
    ./plugins/go.nix
    ./plugins/lint.nix
    ./plugins/oil.nix
    ./plugins/rust.nix
    ./plugins/spider.nix
    ./plugins/telescope.nix
  ];
  programs.nixvim = {
    enable = true;
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };
    plugins = {
      nvim-autopairs.enable = true;
      comment.enable = true;
      guess-indent.enable = true;
      navic.enable = true;
      auto-session = {
        enable = true;
        settings = {
          auto_create = true;
          auto_save = true;
          auto_restore = true;
        };
      };
      fidget.enable = true;
      rainbow-delimiters.enable = true;
      crates.enable = true;
      sandwich.enable = true;
      tmux-navigator.enable = true;
      web-devicons.enable = true;
      smear-cursor.enable = true;
      neoscroll.enable = true;
      precognition.enable = true;
      fastaction.enable = true;
      hardtime.enable = true;
      package-info.enable = true;
      endwise.enable = true;
      auto-save.enable = true;
      gitsigns.enable = true;
      committia.enable = true;
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
      scrolloff = 3;
      wrap = false;
      cursorline = true;
      sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions";
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
      { key = "J"; action = ":m '>+1<cr>gv=gv"; mode = [ "v" ]; }
      { key = "K"; action = ":m '<-2<cr>gv=gv"; mode = [ "v" ]; }
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
      setlocal_frompattern
    ++ builtins.map
      (a: {
        pattern = a.pattern;
        event = [ "BufWritePre" "BufRead" ];
        command = "set filetype=${a.ft}";
      })
      filetypes;

    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "macchiato";
      };
    };
  };
}
