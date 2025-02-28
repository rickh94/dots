{ pkgs
, inputs
, system
, lib
, unstablePkgs
, ...
}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      vim-repeat
      which-key-nvim
      plenary-nvim
      nvim-web-devicons
      dressing-nvim
    ];

    extraPackages = with pkgs; [
      fzf
      pkgs.nodejs
    ];

    extraLuaConfig =
      /*
      lua
      */
      ''
        require('which-key').setup({})
        -- SETTING OPTIONS
        vim.o.hlsearch = false
        vim.o.incsearch = true

        vim.o.number = true
        vim.o.relativenumber = true

        vim.o.mouse = 'nv'
        vim.o.breakindent = true

        vim.o.undofile = true

        vim.o.ignorecase = true
        vim.o.smartcase = true

        vim.wo.signcolumn = 'auto'

        vim.o.updatetime = 50
        vim.o.timeout = true
        vim.o.timeoutlen = 300

        vim.o.completeopt = 'menuone,noselect'

        vim.o.termguicolors = true


        vim.o.swapfile = false
        vim.o.backup = false
        vim.o.undodir = vim.fn.stdpath('state') .. '/undodir'

        vim.o.smartindent = true

        vim.o.scrolloff = 8

        vim.o.wrap = false
        vim.o.cursorline = true

        vim.diagnostic.Opts = {
	  update_in_insert = true
	}


        -- highlight on yank
        local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
        vim.api.nvim_create_autocmd('TextYankPost', {
          callback = function()
            vim.highlight.on_yank()
          end,
          group = highlight_group,
          pattern = '*',
        })

        -- KEYMAP
        vim.g.mapleader = ' '
        vim.g.maplocalleader = ' '

        vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true });

        local wk = require('which-key')

        wk.add({
        {
          -- close buffer
          mode = 'n',
          { '<leader>X', '<cmd>bp<bar>sp<bar>bn<bar>bd<CR>', desc = 'Close current buffer' },
          {'<leader>W', '<cmd>wa<CR>', desc = 'Save all buffers' },
          {'<leader>w', '<cmd>w<CR>', desc = 'Save current buffer' },
        },

        -- DIAGNOSTICS
        {
          mode = 'n',
          group = 'diagnostics',
          {'[d', vim.diagnostic.goto_prev, desc = "Previous diagnostic" },
          {']d', vim.diagnostic.goto_next, desc = "Next diagnostic" },
          {'<leader>d',  function() vim.diagnostic.open_float() end, desc = "Open Diagnostic" },
        },

        -- REBINDS
        {
          mode = 'n',
          { '<C-d>', '<C-d>zz', desc = "Half page jump down with cursor in center" },
          { '<C-u>', '<C-u>zz', desc = "Half page jump up with cursor in center" },
          { 'n', 'nzzzv', desc = "Next search result with cursor in middle" },
          { 'N', 'Nzzzv', desc = "Previous search result with cursor in middle" },
        },

        {
          mode = 'x',
          { '<leaver>p', '"_dP', desc = "Paste over selection without losing current register" }
        },

        {
          mode = {'n', 'v'},
          { '<leader>y', '"+y', desc = "Yank into system keyboard" },
          { '<leader>Y', '"+Y', desc = "Yank line into system keyboard" },
          { '<leader>P', '"+p', desc = "Paste from system keyboard" },
        },

        -- VISUAL MODE KEYBINDS
        {
          mode = 'v',
          group = 'visual mode',
          { '>', '>gv', desc = 'Indent without deselecting' },
          { '<', '<gv', desc = 'Unindent without deselecting' },
          { 'J', ":m '>+1<cr>gv=gv", desc = "Drag lines in visual mode" },
          { 'K', ":m '<-2<cr>gv=gv", desc = "Drag lines in visual mode" },
        },
        })

        -- some filetype defaults
        local twotrue = { 2, true }

        local setlocal_frompattern = {
          ['*.html'] = twotrue,
          ['*.njk'] = twotrue,
          ['*.ts'] = twotrue,
          ['*.tsx'] = twotrue,
          ['*.js'] = twotrue,
          ['*.jsx'] = twotrue,
          ['*.svelte'] = twotrue,
          ['*.vue'] = twotrue,
          ['*.astro'] = twotrue,
          ['*.py'] = { 4, true },
          ['*.c'] = { 8, false },
          ['*.ino'] = { 8, false },
          ['*.ly'] = { 2, false },
          ['*.ily'] = twotrue,
          ['*.nix'] = twotrue,
          ['*.ml'] = twotrue,
          ['*.hcl'] = twotrue,
        }

        for p, s in pairs(setlocal_frompattern) do
          local cmd = 'setlocal tabstop=' .. s[1] .. ' shiftwidth=' .. s[1]
          if s[2] then
            cmd = cmd .. ' expandtab'
          else
            cmd = cmd .. ' noexpandtab'
          end
          vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufRead' }, {
            pattern = p,
            command = cmd,
          })
        end

        vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufRead' }, {
          pattern = '*.sql',
          command = 'setlocal tabstop=4 shiftwidth=4 expandtab',
        })

        local filetypes = {
          ['njk'] = 'twig',
          ['pcss'] = 'css',
          ['astro'] = 'astro',
        }

        for p, t in pairs(filetypes) do
          vim.api.nvim_create_autocmd({ 'BufWritePre', 'BufRead' }, {
            pattern = '*.' .. p,
            command = 'set filetype=' .. t,
          })
        end

        -- Hardwrap in markdown
        vim.api.nvim_create_autocmd({ 'FileType' }, {
          pattern = 'markdown',
          callback = function()
            vim.opt_local.linebreak = true
            vim.opt_local.textwidth = 88
            vim.opt_local.spell = true
            vim.opt_local.spelllang = 'en_us'
          end
        })
      '';
  };
}
