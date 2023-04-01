-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    priority = 100,
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'ray-x/cmp-treesitter',
      -- 'lukas-reineke/cmp-rg',
    },
  },
  -- icons in completions
  'onsails/lspkind.nvim',

  -- Useful plugin to show you pending keybinds.
  {
    'folke/which-key.nvim',
    opts = {},
    config = function()
      require('which-key').register({
        w = {
          name = "+Window",
        },
        b = {
          name = "+Buffer",
        },
        s = {
          name = "+Search",
        },
      }, { prefix = "<leader>" })
    end,
  },
  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  --[[ { -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'onedark'
    end,
  }, ]]

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = 'onedark',
        component_separators = '|',
        section_separators = '',
      },
    },
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    opts = {
      char = '┊',
      show_trailing_blankline_indent = false,
    },
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim',         opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  { 'nvim-telescope/telescope.nvim', version = '*', dependencies = { 'nvim-lua/plenary.nvim' } },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  },
  -- add edgedb support
  'edgedb/edgedb-vim',
  -- fix repeat using . for some plugins
  'tpope/vim-repeat',
  {
    'simrat39/rust-tools.nvim',
    priority = 90,
    config = function()
      require('rust-tools').setup({
        tools = {
          inlay_hints = {
            auto = true
          }
        }
      })
    end
  },
  -- cargo crates resolution
  {
    'saecki/crates.nvim',
    config = function()
      require('crates').setup()
    end
  },
  -- inlay type hints for rust
  {
    'simrat39/inlay-hints.nvim',
    priority = 80,
    config = function()
      require('inlay-hints').setup()
    end
  },
  -- big movements
  {
    'ggandor/leap.nvim',
    config = function()
      require('leap').add_default_mappings()
    end
  },
  -- nice drop in dashboard for bare launches
  {
    'glepnir/dashboard-nvim',
    event = 'VimEnter',
    config = function()
      require('dashboard').setup { -- config
      }
    end,
    dependencies = { { 'nvim-tree/nvim-web-devicons' } }
  },
  -- highlight todo comments
  {
    'folke/todo-comments.nvim',
    config = function()
      require('todo-comments').setup()
    end
  },
  -- something went wrong with this one on nix
  {
    'rcarriga/nvim-notify',
    --[[ config = function()
      vim.notify = require('nvim-notify')
    end ]]
  },
  {
    'echasnovski/mini.indentscope',
    versio = '*',
    config = function()
      require('mini.indentscope').setup()
    end,
  },
  -- automatic pairs, might switch for autopairs
  {
    'echasnovski/mini.pairs',
    version = '*',
    config = function()
      require('mini.pairs').setup()
    end
  },
  -- fancy ui changes, not neovide compatible currently
  --[[ {
    'folke/noice.nvim',
    config = function()
      require('noice').setup()
    end,
    dependencies = {
      { 'MunifTanjim/nui.nvim' },
      { 'rcarriga/nvim-notify' }
    }
  }, ]]
  -- pretty purple color scheme
  {
    'folke/tokyonight.nvim',
    config = function()
      vim.cmd.colorscheme 'tokyonight-storm'
    end
  },
  -- show file tree
  {
    'nvim-tree/nvim-tree.lua',
    config = function()
      require('nvim-tree').setup()
    end
  },
  -- random useful snippets
  'rafamadriz/friendly-snippets',
  -- auto fixing html tags
  {
    'windwp/nvim-ts-autotag',
    config = function()
      require('nvim-ts-autotag').setup()
    end
  },
  -- run database commands from vim
  'tpope/vim-dadbod',
  -- colorful window separators
  --[[ {
    'nvim-zh/colorful-winsep.nvim',
    config = function()
      require('colorful-winsep').setup()
    end
  }, ]]
  -- add brackets and things around stuff
  -- 'machakann/vim-sandwich',
  -- dim inactive areas of code
  {
    'folke/twilight.nvim',
    config = function()
      require('twilight').setup()
    end
  },
  -- auto mkdir -p on save
  'jghauser/mkdir.nvim',
  {
    'sudormrfbin/cheatsheet.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim'
    }
  },
  {
    'tmillr/sos.nvim',
    config = function()
      require('sos').setup({
        enabled = true,
        timeout = 10000,
        autowrite = true,
        save_on_cmd = "some",
        save_on_bufleave = true,
        save_on_focuslost = true,
      })
    end
  },
  {
    'mrjones2014/legendary.nvim',
  },
  'ThePrimeagen/vim-be-good',
  'stevearc/dressing.nvim',
  -- 'ThePrimeagen/harpoon',
  'mbbill/undotree',
  {
    'ray-x/go.nvim',
    dependencies = {
      'ray-x/guihua.lua'
    },
    config = function()
      require('go').setup()
    end,
    event = { "CMdlineEnter" },
    ft = { "go", "gomod" },
  },
  {
    'jose-elias-alvarez/typescript.nvim',
    config = function()
      require('typescript').setup({})
    end
  },
  -- 'sheerun/vim-polyglot',
  -- 'github/copilot.vim',
  {
    'zbirenbaum/copilot.lua',
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end
  },
  {
    'zbirenbaum/copilot-cmp',
    after = { "copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end
  }
}, {})

-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = false
vim.o.incsearch = true

-- Make line numbers default
vim.o.number = true
vim.o.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
-- vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = false

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 50
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

vim.o.guifont = "VictorMono Nerd Font:11"

vim.o.expandtab = true

vim.o.swapfile = false
vim.o.backup = false
vim.o.undodir = vim.fn.stdpath('state') .. '/.local/state/nvim/undodir'
vim.o.smartindent = true

vim.o.scrolloff = 8

vim.o.colorcolumn = "80"
vim.o.wrap = false



-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
-- vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
-- vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- require('telescope').load_extension('harpoon')

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

require('legendary').setup({
  keymaps = {
    {
      '<leader>?',
      { n = require('telescope.builtin').oldfiles },
      description = 'Find recently opened files'
    },
    {
      '<leader><space>',
      { n = require('telescope.builtin').buffers },
      description = 'Find open buffers'
    },
    {
      '<leader>/',
      {
        n = function()
          require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
          })
        end
      },
      description = "Fuzzily search in current buffer"
    },
    {
      itemgroup = 'search',
      description = '+Search',
      icon = 'S',
      keymaps = {
        {
          '<leader>sf',
          {
            n = require('telescope.builtin').find_files
          },
          description = "Telescope Search Files"
        },
        {
          '<leader>sh',
          {
            n = require('telescope.builtin').help_tags
          },
          description = "Telescope Search Help Tags"
        },
        {
          '<leader>sw',
          {
            n = require('telescope.builtin').grep_string
          },
          description = 'Search Current Word'
        },
        {
          '<leader>sg',
          {
            n = require('telescope.builtin').live_grep
          },
          description = 'Search by Grep'
        },
        {
          '<leader>sd',
          {
            n = require('telescope.builtin').diagnostics
          },
          description = 'Search Diagnostics'
        },
        {
          '<leader>sm',
          {
            n = '<cmd>Telescope harpoon marks<cr>'
          },
          description = 'Search harpoon marks'
        }
      }
    },
    {
      itemgroup = 'window',
      description = '+Window',
      icon = 'W',
      keymaps = {
        {
          '<leader>wk',
          {
            n = '<C-w>k',
          },
          description = 'Window Up'
        },
        {
          '<leader>wj',
          {
            n = '<C-w>j',
          },
          description = 'Window Down'
        },
        {
          '<leader>wh',
          {
            n = '<C-w>h',
          },
          description = 'Window Left'
        },
        {
          '<leader>wl',
          {
            n = '<C-w>l',
          },
          description = 'Window Right'
        },
        {
          '<leader>ws',
          {
            n = '<C-w>s',
          },
          description = 'Window Split'
        },
        {
          '<leader>wv',
          {
            n = '<C-w>v',
          },
          description = 'Window Vertical Split'
        },
        {
          '<leader>wq',
          {
            n = '<C-w>q',
          },
          description = 'Close Window'
        },
        {
          '<leader>wt',
          {
            n = '<C-w>T',
          },
          description = 'Window split to new tab'
        },
      }
    },
    {
      itemgroup = 'buffer',
      description = '+Buffer',
      icon = 'B',
      keymaps = {
        {
          '<leader>bc',
          {
            n = '<cmd>bp<bar>sp<bar>bn<bar>bd<CR>'
          },
          description = 'Close Current Buffer'
        },
        {
          '<leader>bn',
          {
            n = '<cmd>bn<CR>'
          },
          description = 'Next Buffer'
        },
        {
          '<leader>bp',
          {
            n = '<cmd>bp<CR>'
          },
          description = 'Previous Buffer'
        },
      }
    },
    {
      itemgroup = 'visindent',
      description = 'Visual Mode Indent/Unindent',
      icon = '>',
      keymaps = {
        {
          '>',
          { v = '>gv' },
          description = "Indent once without deselecting"
        },
        {
          '<',
          { v = '<gv' },
          description = "Unindent once without deselecting"
        },
      }
    },
    {
      '<leader>e',
      {
        n = '<cmd>NvimTreeToggle<cr>'
      },
      description = 'Open or close file tree'
    },
    {
      '<leader>o',
      {
        n = '<cmd>NvimTreeFocus<cr>'
      },
      description = 'Focus File tree'
    },
    {
      '<leader>t',
      { n = '<cmd>TodoTelescope<cr>' },
      description = 'Search Project Todos'
    },
    {
      '<leader>T',
      { n = '<cmd>Twilight<cr>' },
      description = 'Toggle Twilight dimming'
    },
    {
      itemgroup = 'diag',
      description = 'Diagnostic Keymaps',
      icon = 'D',
      keymaps = {
        {
          '[d',
          { n = vim.diagnostic.goto_prev },
          description = "Go to previous diagnostic"
        },
        {
          ']d',
          { n = vim.diagnostic.goto_next },
          description = "Go to next diagnostic"
        },
        {
          '<leader>d',
          { n = vim.diagnostic.open_float },
          description = 'Open Diagnostic Float'
        }
      }
    },
    {
      '<leader>p',
      {
        n = '<cmd>Legendary<cr>'
      },
      description = 'Open Legendary command prompt'
    }
  },
  {
    '<leader>u',
    { n = vim.cmd.UndotreeToggle },
    description = 'Open Undo Tree'
  },
  --[[ {
    itemgroup = 'harpoon',
    description = '+Harpoon',
    icon = 'H',
    keymaps = {
      {
        '<leader>hq',
        { n = require('harpoon.ui').toggle_quick_menu() },
        description = 'Show/hide harpoon quick menu'
      },
      {
        '<leader>ha',
        { n = require('harpoon.mark').add_file() },
        description = 'Add file to harpoon marks'
      },
      {
        '<leader>h1',
        { n = require('harpoon.mark').nav_file(1) },
        description = 'Nav to file number'
      },
      {
        '<leader>h2',
        { n = require('harpoon.mark').nav_file(2) },
        description = 'Nav to file number'
      },
      {
        '<leader>h3',
        { n = require('harpoon.mark').nav_file(3) },
        description = 'Nav to file number'
      },
      {
        '<leader>h4',
        { n = require('harpoon.mark').nav_file(4) },
        description = 'Nav to file number'
      },
      {
        '<leader>h5',
        { n = require('harpoon.mark').nav_file(5) },
        description = 'Nav to file number'
      },
      {
        '<leader>h6',
        { n = require('harpoon.mark').nav_file(6) },
        description = 'Nav to file number'
      },
      {
        '<leader>h1',
        { n = require('harpoon.mark').nav_file(1) },
        description = 'Nav to file number'
      },
      {
        '<leader>h8',
        { n = require('harpoon.mark').nav_file(8) },
        description = 'Nav to file number'
      },
      {
        '<leader>h9',
        { n = require('harpoon.mark').nav_file(9) },
        description = 'Nav to file number'
      },
      {
        '<leader>h0',
        { n = require('harpoon.mark').nav_file(10) },
        description = 'Nav to file number'
      },
      {
        '<leader>hh',
        { n = require('harpoon.mark').nav_prev() },
        description = 'Navigate to previous harpoon'
      },
      {
        '<leader>hl',
        { n = require('harpoon.mark').nav_next() },
        description = 'Navigate to next harpoon'
      },
    },
  },  ]]
  {
    "J",
    { v = ":m '>+1<cr>gv=gv" },
    description = "Drag lines around in visual mode with indenting"
  },
  {
    "K",
    { v = ":m '<-2<cr>gv=gv" },
    description = "Drag lines around in visual mode with indenting"
  },
  {
    '<C-d>',
    { n = '<C-d>zz' },
    description = "Half page jump with cursor in center"
  },
  {
    '<C-u>',
    { n = '<C-u>zz' },
    description = "Half page jump with cursor in center"
  },
  {
    'n',
    { n = 'nzzzv' },
    description = 'Next search result with cursor in middle'
  },
  {
    'N',
    { n = 'Nzzzv' },
    description = 'Prev search result with cursor in middle'
  },
  {
    '<leader>p',
    { x = '"_dP' },
    description = 'Paste over without losing current register'
  },
  {
    '<leader>y',
    {
      n = '"+y',
      v = '"+y'
    },
    description = "Yank into system clipboard"
  },
  {
    '<leader>Y',
    {
      n = '"+Y',
    },
    description = "Yank line into system clipboard"
  },
  {
    '<leader>P',
    {
      n = '"+p',
    },
    description = "Paste from system clipboard"
  },
  which_key = {
    auto_register = true,
  }
})


-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'help', 'vim', 'nix' },

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = true,

  highlight = { enable = true },
  indent = { enable = true, disable = { 'python', 'html' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    --[[ swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    }, ]]
  },
}

-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = '[L]SP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  require('legendary').setup({
    keymaps = {
      {
        '<leader>r',
        {
          n = vim.lsp.buf.rename,
        },
        description = 'LSP rename symbol'
      },
      {
        '<leader>a',
        {
          n = vim.lsp.buf.code_action,
        },
        description = 'LSP: Action'
      },
      {
        'gd',
        {
          n = vim.lsp.buf.definition,
        },
        description = 'Goto Definition'
      },
      {
        'gr',
        {
          n = require('telescope.builtin').lsp_references,
        },
        description = 'Goto References'
      },
      {
        'gI',
        {
          n = vim.lsp.buf.implementation
        },
        description = 'Goto Implementation'
      },
      {
        '<leader>D',
        {
          n = vim.lsp.buf.type_definition
        },
        description = 'Type Definition'
      },
      {
        'K',
        {
          n = vim.lsp.buf.hover
        },
        description = 'Hover Documentation'
      },
      {
        '<C-k>',
        {
          n = vim.lsp.buf.signature_help
        },
        description = 'Signature Documentation'
      },
      {
        'gD',
        { n = vim.lsp.buf.declaration },
        description = 'Goto Declaration'
      }

    }
  })
  -- nmap('<leader>r', vim.lsp.buf.rename, 'Rename')
  -- nmap('<leader>a', vim.lsp.buf.code_action, 'Action')

  -- nmap('gd', vim.lsp.buf.definition, 'Goto Definition')
  -- nmap('gr', require('telescope.builtin').lsp_references, 'Goto References')
  -- nmap('gI', vim.lsp.buf.implementation, 'Goto Implementation')
  -- nmap('<leader>D', vim.lsp.buf.type_definition, 'Type Definition')
  -- not active
  -- nmap('<leader>ls', require('telescope.builtin').lsp_document_symbols, 'Document symbols')
  -- nmap('<leader>lS', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Workspace Symbols')

  -- See `:help K` for why this keymap
  -- nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  -- nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  -- nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  -- nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  -- nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  -- nmap('<leader>wf', function()
  --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  -- end, 'Workspace List Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  -- clangd = {},
  -- gopls = {},
  pyright = {
    pyright = { autoImportCompletion = true, },
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = 'openFilesOnly',
        useLibraryCodeForTypes = true,
        typeCheckingMode = 'off'
      }
    }
  },
  -- rust_analyzer = {},
  -- tsserver = {},

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}

require('lspconfig').lua_ls.setup {
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      }
    }
  }
}

require('lspconfig').emmet_ls.setup {
  capabilities = capabilities,
  filetypes = { 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less', 'svelte', 'vue',
    'djangohtml', 'twig', 'astro' },
}

-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'

luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'copilot' },
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    -- { name = 'treesitter' },
    { name = 'path' },
    -- { name = 'rg' },
  },
  formatting = {
    format = require('lspkind').cmp_format({
      mode = 'symbol',
      maxwidth = 50,
      ellipsis_char = '...',
      before = function(entry, vim_item)
        return vim_item
      end
    })
  }
}

cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- vim.cmd [[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]

-- autoformat on save
local formatOnSave = { "html", "go", "rs", "js", "css", "json", "ex", "rb", "vue", "c", "cpp", "java", "nix", "ts",
  "lua", "nix", "astro" }
for _, v in pairs(formatOnSave) do
  vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = "*." .. v,
    callback = function(_)
      vim.lsp.buf.format()
    end
  })
end

vim.api.nvim_create_autocmd({ "BufRead" }, {
  pattern = "*.html",
  command = "setlocal tabstop=2 shiftwidth=2 expandtab",
})

vim.api.nvim_create_autocmd({ "BufRead" }, {
  pattern = "*.ts[x?]",
  command = "setlocal tabstop=2 shiftwidth=2 expandtab",
})

vim.api.nvim_create_autocmd({ "BufRead" }, {
  pattern = "*.js[x?]",
  command = "setlocal tabstop=2 shiftwidth=2 expandtab",
})

vim.api.nvim_create_autocmd({ "BufRead" }, {
  pattern = "*.svelte",
  command = "setlocal tabstop=2 shiftwidth=2 expandtab",
})

vim.api.nvim_create_autocmd({ "BufRead", "BufWritePre" }, {
  pattern = "*.astro",
  command = "setlocal tabstop=2 shiftwidth=2 expandtab",
})

vim.api.nvim_create_autocmd({ "BufRead" }, {
  pattern = "*.c",
  command = "setlocal tabstop=8 shiftwidth=8 noexpandtab",
})

-- Custom filetypes from regex
-- use syntax filetype[ext] = "filetype"
local filetypes = {}
filetypes["njk"] = "twig"
filetypes["pcss"] = "css"
filetypes["astro"] = "astro"


for k, v in pairs(filetypes) do
  vim.api.nvim_create_autocmd({ "BufWritePre", "BufRead" }, {
    pattern = "*." .. k,
    command = "set filetype=" .. v
  })
end

require('rust-tools').inlay_hints.enable()
-- lspkind.lua
require("lspkind").init({
  symbol_map = {
    Copilot = "",
  },
})

vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })



-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
