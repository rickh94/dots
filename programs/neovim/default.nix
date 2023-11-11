{ pkgs, inputs, system, lib, unstablePkgs, ... }:
{
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

    extraPackages = with pkgs;[
      fzf
    ];

    extraLuaConfig = /* lua */ ''
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

      vim.o.colorcolumn = "88"
      vim.o.wrap = false
      vim.o.nowrap = true
      vim.o.cursorline = true


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

      wk.register({
        -- close buffer
        x = { '<cmd>bp<bar>sp<bar>bn<bar>bd<CR>', 'Close current buffer' },
      }, { prefix = '<leader>', mode = 'n' })


      -- DIAGNOSTICS
      wk.register({
        ['['] = {
          d = { vim.diagnostic.goto_prev, "Previous diagnostic" },
        },
        [']'] = {
          d = { vim.diagnostic.goto_next, "Next diagnostic" },
        },
        ['<leader>'] = {
          d = { function() vim.diagnostic.open_float() end, "Open Diagnostic" },
        },
      }, { mode = 'n' })

      -- REBINDS
      wk.register({
        ['<C-d>'] = { '<C-d>zz', "Half page jump with cursor in center" },
        ['<C-u>'] = { '<C-u>zz', "Half page jump with cursor in center" },
        n = { 'nzzzv', "Next search result with cursor in middle" },
        N = { 'Nzzzv', "Previous search result with cursor in middle" },
      }, { mode = 'n' })

      wk.register({
        p = { '"_dP', "Paste over selection without losing current register" }
      }, { mode = 'x', prefix = '<leader>' })

      wk.register({
        y = { '"+y', "Yank into system keyboard" },
        Y = { '"+Y', "Yank line into system keyboard" },
        P = { '"+p', "Paste from system keyboard" },
      }, { mode = { 'n', 'v' }, prefix = '<leader>' })

      -- VISUAL MODE KEYBINDS
      wk.register({
        ['>'] = { '>gv', 'Indent without deselecting' },
        ['<'] = { '<gv', 'Unindent without deselecting' },
        J = { ":m '>+1<cr>gv=gv", "Drag lines in visual mode" },
        K = { ":m '<-2<cr>gv=gv", "Drag lines in visual mode" },
      }, { mode = 'v' })

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
        ['*.ly'] = { 2, false },
        ['*.ily'] = twotrue,
        ['*.nix'] = twotrue,
        ['*.ml'] = twotrue,
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
          vim.opt_local.textwidth = 80
          vim.opt_local.spell = true
          vim.opt_local.spelllang = 'en_us'
        end
      })
    '';
  };
}
