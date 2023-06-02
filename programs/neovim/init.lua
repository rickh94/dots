-- PLUGINS
--
-- bootstrap lazy
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- git plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- autodetect ts and sw
  -- 'tpope/vim-sleuth',
  {
    'NMAC427/guess-indent.nvim',
    config = function()
      require('guess-indent').setup({})
    end
  },

  -- fix behavior of .
  'tpope/vim-repeat',

  -- save undo history nicely
  'mbbill/undotree',

  -- auto mkdir -p on save
  'jghauser/mkdir.nvim',

  -- autosave on pause or leave
  {
    'tmillr/sos.nvim',
    config = function()
      require('sos').setup({
        enabled = true,
        timeout = 20000,
        autowrite = true,
        save_on_cmd = "some",
        save_on_bufleave = true,
        save_on_focuslost = true,
      })
    end
  },


  -- shortcuts to toggle comments
  { 'numToStr/Comment.nvim', opts = {} },

  -- which key
  {
    'folke/which-key.nvim',
    config = function()
      require('which-key').setup({})
    end
  },
  -- telescope
  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
    }
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end
  },
  -- file tree
  {
    'nvim-tree/nvim-tree.lua',
    config = function()
      require('nvim-tree').setup()
    end,
  },

  -- treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/nvim-treesitter-context',
    },
    config = function()
      pcall(require('nvim-treesitter.install').update({ with_sync = true }))
    end,
  },

  -- lsp configuration and plugins
  {
    'neovim/nvim-lspconfig',
    priority = 100,
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      -- lsp status updates
      { 'j-hui/fidget.nvim', opts = {} },
      -- additional lua config for nvim stuff
      'folke/neodev.nvim',
    },
  },
  -- pretty icons for completions
  'onsails/lspkind.nvim',

  -- completion plugins
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'lukas-reineke/cmp-rg',
    },
  },

  -- bracket related plugins
  {
    'echasnovski/mini.pairs',
    version = '*',
    config = function()
      require('mini.pairs').setup()
    end,
  },
  'machakann/vim-sandwich',

  -- git signs in gutter
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      }
    }
  },

  -- pretty statusline
  {
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        icons_enabled = false,
        component_separators = '|',
        section_separators = '',
      }
    }
  },

  -- indent blankline and scope
  {
    'lukas-reineke/indent-blankline.nvim',
    opts = {
      char = '┊',
      show_trailing_blankline_indent = false,
    }
  },
  {
    'echasnovski/mini.indentscope',
    version = '*',
    config = function()
      require('mini.indentscope').setup()
    end,
  },


  -- language support plugins
  -- edgedb
  'edgedb/edgedb-vim',
  'NoahTheDuke/vim-just',

  -- rust
  {
    'simrat39/rust-tools.nvim',
    priority = 90,
    config = function()
      require('rust-tools').setup({
        tools = {
          inlay_hints = {
            auto = true,
          },
        },
      })
    end
  },
  {
    'simrat39/inlay-hints.nvim',
    priority = 80,
    config = function()
      require('inlay-hints').setup()
    end
  },
  {
    'saecki/crates.nvim',
    config = function()
      require('crates').setup()
    end
  },

  -- html
  {
    'windwp/nvim-ts-autotag',
    config = function()
      require('nvim-ts-autotag').setup()
    end
  },

  -- go
  {
    'ray-x/go.nvim',
    dependencies = {
      'ray-x/guihua.lua'
    },
    config = function()
      require('go').setup()
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
  },

  -- typescript
  {
    'jose-elias-alvarez/typescript.nvim',
    config = function()
      require('typescript').setup({})
    end,
  },

  -- css
  'ap/vim-css-color',

  -- copilot
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  },
  {
    'zbirenbaum/copilot-cmp',
    after = { 'copilot.lua' },
    config = function()
      require('copilot_cmp').setup()
    end
  },

  -- random snippets
  'rafamadriz/friendly-snippets',

  -- ui changes
  -- themes
  'folke/tokyonight.nvim',
  'LunarVim/onedarker.nvim',
  'ellisonleao/gruvbox.nvim',
  'bluz71/vim-nightfly-colors',
  'bluz71/vim-moonfly-colors',
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    config = function()
      require('catppuccin').setup({
        flavor = "mocha",
      })
    end
  },
  {
    'yorik1984/newpaper.nvim',
    config = function()
      require('newpaper').setup({ style = 'dark' })
    end,
  },

  -- dashboard
  {
    'glepnir/dashboard-nvim',
    event = 'VimEnter',
    config = function()
      require('dashboard').setup({})
    end,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    }
  },

  -- prettier notifications
  -- 'rcarriga/nvim-notify',

  -- prettier ui elements
  'stevearc/dressing.nvim',

  -- transparency
  {
    'xiyaowong/nvim-transparent',
    config = function()
      require("transparent").setup({
        groups = { -- table: default groups
          'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
          'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
          'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
          'SignColumn', 'CursorLineNr', 'EndOfBuffer',
        },
        extra_groups = {},   -- table: additional groups that should be cleared
        exclude_groups = {}, -- table: groups you don't want to clear
      })
    end,
    lazy = false,
  },

  -- highlight todo comments
  {
    'folke/todo-comments.nvim',
    config = function()
      require('todo-comments').setup()
    end
  },

  -- twilight dim code
  {
    'folke/twilight.nvim',
    config = function()
      require('twilight').setup()
    end
  },

  -- presist sessions
  {
    'folke/persistence.nvim',
    config = function()
      require('persistence').setup()
    end,
  },

  -- null ls
  {
    'jose-elias-alvarez/null-ls.nvim',
    config = function()
      local null_ls = require('null-ls')
      null_ls.setup({
        sources = {
          null_ls.builtins.code_actions.eslint_d,
          null_ls.builtins.code_actions.proselint,
          null_ls.builtins.code_actions.refactoring,
          null_ls.builtins.code_actions.shellcheck,
          null_ls.builtins.formatting.djlint,
          null_ls.builtins.formatting.isort,
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.json_tool,
          null_ls.builtins.formatting.just,
          null_ls.builtins.diagnostics.djlint,
          null_ls.builtins.diagnostics.jshint,
          null_ls.builtins.diagnostics.jsonlint,
          -- null_ls.builtins.diagnostics.markuplint,
          null_ls.builtins.diagnostics.proselint,
          null_ls.builtins.diagnostics.sqlfluff,
          null_ls.builtins.diagnostics.standardjs,
          null_ls.builtins.diagnostics.stylelint,
          null_ls.builtins.diagnostics.vulture,
        }
      })
    end
  },

  -- lilypond
  {
    'martineausimon/nvim-lilypond-suite',
    dependencies = 'MunifTanjim/nui.nvim',
    config = function()
      require('nvls').setup({
        lilypond = {
          mappings = {
            player = "<F3>",
            compile = "<F5>",
            open_pdf = "<F6>",
            switch_buffers = "<A-Space>",
            insert_version = "<F4>",
            hyphenation = "<F12>",
            hyphenation_change_lang = "<F11>",
            insert_hyphen = "<leader>ih",
            add_hyphen = "<leader>ah",
            del_next_hyphen = "<leader>dfh",
            del_prev_hyphen = "<leader>dFh",
            del_selected_hyphen = "<leader>dh"
          },
          options = {
            pitches_language = "default",
            output = "pdf",
            main_file = "main.ly",
            main_folder = "%:p:h",
            include_dir = "$HOME",
            hyphenation_language = "en_DEFAULT"
          },
          highlights = {
            lilyString = { link = "String" },
            lilyDynamic = { bold = true },
            lilyComment = { link = "Comment" },
            lilyNumber = { link = "Number" },
            lilyVar = { link = "Tag" },
            lilyBoolean = { link = "Boolean" },
            lilySpecial = { bold = true },
            lilyArgument = { link = "Type" },
            lilyScheme = { link = "Special" },
            lilyLyrics = { link = "Special" },
            lilyMarkup = { bold = true },
            lilyFunction = { link = "Statement" },
            lilyArticulation = { link = "PreProc" },
            lilyContext = { link = "Type" },
            lilyGrob = { link = "Include" },
            lilyTranslator = { link = "Type" },
            lilyPitch = { link = "Function" },
            lilyChord = {
              ctermfg = "lightMagenta",
              fg = "lightMagenta",
              bold = true
            },
          },
        },
        latex = {
          mappings = {
            compile = "<F5>",
            open_pdf = "<F6>",
            lilypond_syntax = "<F3>"
          },
          options = {
            clean_logs = false,
            main_file = "main.tex",
            main_folder = "%:p:h",
            include_dir = nil,
            lilypond_syntax_au = "BufEnter"
          },
        },
        player = {
          mappings = {
            quit = "q",
            play_pause = "p",
            loop = "<A-l>",
            backward = "h",
            small_backward = "<S-h>",
            forward = "l",
            small_forward = "<S-l>",
            decrease_speed = "j",
            increase_speed = "k",
            halve_speed = "<S-j>",
            double_speed = "<S-k>",
            mpv_flags = {
              "--msg-level=cplayer=no,ffmpeg=no",
              "--loop",
              "--config-dir=/dev/null"
            }
          },
          options = {
            row = "2%",
            col = "99%",
            width = "37",
            height = "1",
            border_style = "single",
            winhighlight = "Normal:Normal,FloatBorder:Normal"
          },
        },
      })
    end
  }
})



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
vim.o.guifont = "VictorMono Nerd Font:11"


vim.o.swapfile = false
vim.o.backup = false
vim.o.undodir = vim.fn.stdpath('state') .. '/undodir'

vim.o.smartindent = true

vim.o.scrolloff = 8

vim.o.colorcolumn = "80"
vim.o.wrap = false

-- highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- PLUGIN SETUP
require('telescope').setup({
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      }
    }
  }
})
pcall(require('telescope').load_extension, 'fzf')

require('rust-tools').inlay_hints.enable()

require('lspkind').init({
  symbol_map = {
    Copilot = ""
  }
})

vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })

-- KEYMAP
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true });

local wk = require('which-key')

-- WINDOW KEYBINDS
wk.register({
  w = {
    name = "+Window",
    k = { '<C-w>k', 'Window Up' },
    j = { '<C-w>j', 'Window Down' },
    h = { '<C-w>h', 'Window Left' },
    l = { '<C-w>l', 'Window Right' },
    q = { '<C-w>q', 'Close Window' },
    s = { '<C-w>s', 'Horizontal Split' },
    v = { '<C-w>v', 'Horizontal Split' },
  },
}, { prefix = '<leader>', mode = 'n' })

wk.register({
  k = { '<C-w>k', 'Window Up' },
  j = { '<C-w>j', 'Window Down' },
  h = { '<C-w>h', 'Window Left' },
  l = { '<C-w>l', 'Window Right' }
}, { prefix = '<leader>', mode = 'n' })

-- BUFFER KEYBINDS
wk.register({
  b = {
    name = "+Buffer",
    c = { '<cmd>bp<bar>sp<bar>bn<bar>bd<CR>', 'Close current buffer' },
  },
}, { prefix = '<leader>' })

-- SEARCH AND TELESCOPE KEYBINDS
wk.register({
  s = {
    name = "+Search",
    f = { function() require('telescope.builtin').find_files() end, "Search Files" },
    h = { function() require('telescope.builtin').help_tags() end, "Search Help tags" },
    w = { function() require('telescope.builtin').grep_string() end, "Search current word" },
    g = { function() require('telescope.builtin').live_grep() end, "Search with grep" },
    d = { function() require('telescope.builtin').diagnostics() end, "Search Diagnostics" },
  },
  t = { '<cmd>TodoTelescope<cr>', 'Search Todos' },
}, { prefix = '<leader>', mode = 'n' })

wk.register({
  ['?'] = { function() require("telescope.builtin").oldfiles() end, "Recent files" },
  ['<Space>'] = { function() require('telescope.builtin').buffers() end, "Open files" },
  ['/'] = { function()
    require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      winblend = 10,
      previewer = false,
    })
  end, "Fuzzy search buffer" },
}, { prefix = '<leader>', mode = 'n' })

-- SESSION KEYBINDS
wk.register({
  q = {
    name = "+Session",
    s = { function() require('persistence').load() end, "Load Session for Directory" },
    l = { function() require('persistence').load({ last = true }) end, "Load Last Session" },
    d = { function() require('persistence').top() end, "Don't save session" },
  }
}, { mode = 'n', prefix = '<leader>' })

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
}, { mode = 'x', previx = '<leader>' })

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


wk.register({
  -- NVIM TREE KEYBINDS
  e = { '<cmd>NvimTreeToggle<cr>', 'Open/close file tree' },
  o = { '<cmd>NvimTreeFocus<cr>', 'Focus file tree' },
  u = { vim.cmd.UndotreeToggle, "Open Undo Tree" },
}, { mode = 'n', prefix = '<leader>' })


-- TREESITTER CONFIGURATION
require('nvim-treesitter.configs').setup({
  ensure_installed = {
    'c',
    'go',
    'lua',
    'python',
    'rust',
    'tsx',
    'typescript',
    'vim',
    'nix',
    'bash',
    'svelte',
    'astro',
  },
  auto_install = true,
  highlight = { enable = true },
  indent = { enable = false, },
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
      lookahead = true,
      keymaps = {
        ['aa'] = '@parameter.outer',
        ['ia'] = '@paramemter,inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true,
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
  },
})


-- LSP CONFIGURATION
local on_attach = function(_, bufnr)
  -- LSP Keybindings
  wk.register({
    r = { function() vim.lsp.buf.rename() end, "Rename Symbol" },
    a = { function() vim.lsp.buf.code_action() end, "Code Action" },
    D = { function() vim.lsp.buf.type_definition() end, "Type Definition" },
  }, { mode = 'n', prefix = '<leader>' })

  wk.register({
    d = { function() vim.lsp.buf.definition() end, "Goto Definition" },
    r = { function() require('telescope.builtin').lsp_references() end, "Goto References" },
    I = { function() vim.lsp.buf.implementation() end, "Goto Implementation" },
    D = { function() vim.lsp.buf.declaration() end, "Goto Implementation" },
  }, { mode = 'n', prefix = 'g' })

  wk.register({
    K = { function() vim.lsp.buf.hover() end, "Hover Documentation" },
  }, { mode = 'n' })

  wk.register({
    ['<C-k>'] = { function() vim.lsp.buf.signature_help() end, "Signature Documentation" },
  }, { mode = 'n' })

  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- LSP Server Setup
local servers = {
  pyright = {
    pyright = { autoImportCompletion = true },
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = 'openFilesOnly',
        useLibraryCodeFOrTypes = true,
        typeCheckingMode = 'off'
      },
    },
  },
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      diagnostics = {
        globals = { 'vim' },
      },
    },
  },
  clangd = {},
  emmet_ls = {
    capabilities = capabilities,
    filetypes = {
      'html',
      'typescriptreact',
      'javascriptreact',
      'css',
      'sass',
      'scss',
      'less',
      'svelte',
      'vue',
      'htmldjango',
      'twig',
      'astro',
    },
  },
  gopls = {},
  rust_analyzer = {},
  svelte = {},
  html = {},
  astro = {},
  eslint = {},
}

require('neodev').setup()
require('mason').setup()


local mason_lspconfig = require('mason-lspconfig')

mason_lspconfig.setup({ ensure_installed = vim.tbl_keys(servers), })

mason_lspconfig.setup_handlers({
  function(server_name)
    require('lspconfig')[server_name].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    })
  end,
})

require('lspconfig').tsserver.setup({
  root_dir = require('lspconfig').util.root_pattern("package.json"),
  single_file_support = false
})

require('lspconfig').denols.setup({
  root_dir = require('lspconfig').util.root_pattern("deno.json"),
})



-- COMPLETION SETUP
local cmp = require('cmp')
local luasnip = require('luasnip')

luasnip.config.setup()

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete({}),
    ['<C-y>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
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
  }),
  sources = {
    { name = 'nvim_lsp', max_item_count = 10 },
    { name = 'buffer',   max_item_count = 2 },
    { name = 'copilot',  max_item_count = 2 },
    { name = 'luasnip',  max_item_count = 2 },
    { name = 'rg',       max_item_count = 1 }
  },
  formatting = {
    format = require('lspkind').cmp_format({
      mode = 'symbol',
      maxwidth = 50,
      ellipsis_char = '...',
      before = function(_, vim_item)
        return vim_item
      end
    })
  },
})

cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer', max_item_count = 10 }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path', max_item_count = 10 }
  }, {
    { name = 'cmdline', max_item_count = 10 }
  })
})

-- autoformat on save
local format_on_save_ext = {
  "go", "rs", "css", "json", "ex", "rb", "vue", "c", "cpp", "java",
  "nix", "ts", "lua", "astro", "tsx", "py",
}

for _, v in pairs(format_on_save_ext) do
  vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = "*." .. v,
    callback = function(_)
      vim.lsp.buf.format()
    end
  })
end

local twotrue = { 2, true }

local setlocal_frompattern = {
  ['*.html'] = twotrue,
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

-- local color = {
--   ['lua']    = 'gruvbox',
--   ['bash']   = 'gruvbox',
--   ['nix']    = 'gruvbox',
--   ['rs']     = 'moonfly',
--   ['c']      = 'moonfly',
--   ['go']     = 'newpaper',
--   ['ts']     = 'catppuccin-mocha',
--   ['js']     = 'catppuccin-mocha',
--   ['jsx']    = 'nightfly',
--   ['tsx']    = 'nightfly',
--   ['vue']    = 'onedarker',
--   ['svelte'] = 'onedarker',
--   ['html']   = 'onedarker',
--   ['astro']  = 'onedarker',
--   ['css']    = 'onedarker',
--   ['md']     = 'onedarker',
--   ['njk']    = 'onedarker',
--   ['py']     = 'tokyonight-storm',
--   ['ly']     = 'nightfly'
-- }
--
-- for p, c in pairs(color) do
--   vim.api.nvim_create_autocmd({ 'BufRead', 'BufEnter' }, {
--     pattern = '*.' .. p,
--     command = 'colorscheme ' .. c,
--   })
-- end

vim.cmd.colorscheme('tokyonight-night')
-- lilypond configuration
vim.api.nvim_create_autocmd('BufEnter', {
  command = "syntax sync fromstart",
  pattern = { '*.ly', '*.ily', '*.tex' }
})

-- vim.api.nvim_create_autocmd('ColorScheme', {
--   command = "highlight Normal ctermbg=NONE guibg=NONE",
--   pattern = "*",
-- })


vim.api.nvim_create_autocmd({ 'BufEnter', 'BufRead' }, {
  command = "lua require('nvls').setup()",
  pattern = { '*.ly', '*.ily', '*.tex' },
})

-- vim.api.nvim_create_autocmd({ 'BufEnter' }, {
--   command = "set smartindent",
--   pattern = { '*.tsx' },
-- })


-- vim: se ft=lua sw=2 ts=2 expandtab:
