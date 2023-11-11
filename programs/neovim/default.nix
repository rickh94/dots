{ pkgs, inputs, system, lib, ... }:
let
  pluginGit = ref: repo: pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "${lib.strings.sanitizeDerivationName repo}";
    version = ref;
    src = builtins.fetchGit {
      url = "https://github.com/${repo}.git";
      ref = ref;
    };
  };

  # always installs latest version
  plugin = pluginGit "HEAD";

in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      guess-indent-nvim
      vim-repeat
      undotree
      (plugin "hiphish/rainbow-delimiters.nvim")
      (plugin "tmillr/sos.nvim")
      comment-nvim
      which-key-nvim
      vim-tmux-navigator
      telescope-nvim
      plenary-nvim
      telescope-fzf-native-nvim
      telescope-file-browser-nvim
      nvim-web-devicons
      harpoon
      nvim-tree-lua
      nvim-treesitter.withAllGrammars
      nvim-treesitter-textobjects
      nvim-lspconfig
      mason-nvim
      mason-lspconfig-nvim
      neodev-nvim
      lspkind-nvim
      lsp-inlayhints-nvim
      nvim-cmp
      cmp-nvim-lsp
      luasnip
      cmp_luasnip
      cmp-fuzzy-buffer
      cmp-path
      friendly-snippets
      vim-sandwich
      gitsigns-nvim
      rust-tools-nvim
      crates-nvim
      nvim-ts-autotag
      (plugin "themaxmarchuk/tailwindcss-colors.nvim")
      go-nvim
      (plugin "pmizio/typescript-tools.nvim")
      catppuccin-nvim
      dressing-nvim
      todo-comments-nvim
      persistence-nvim
      nvim-lint
      formatter-nvim
      (plugin "martineausimon/nvim-lilypond-suite")
      (plugin "MunifTanjim/nui.nvim")
    ];

    extraPackages = with pkgs;[
      tree-sitter
      nodePackages.typescript
      nodePackages.typescript-language-server
      gopls
      nodePackages.pyright
      rust-analyzer
      fzf
      lua-language-server
      nodePackages.svelte-language-server
      nodePackages.intelephense
      nodePackages.vscode-langservers-extracted
      nodePackages.pyright
      nodePackages.prettier
      nodePackages.eslint
      nodePackages.stylelint
      nodePackages.jsonlint
      isort
      mypy
      pylint
      ruff
      black
    ];

    extraLuaConfig = /* lua */ ''
      require('sos').setup({
          enabled = true,
          timeout = 20000,
          autowrite = true,
          save_on_cmd = "some",
          save_on_bufleave = false,
          save_on_focuslost = true,
        })

      require('which-key').setup({})

      require('harpoon').setup({
        global_settings = {
          -- sets the marks upon calling `toggle` on the ui, instead of require `:w`.
          save_on_toggle = false,

          -- saves the harpoon file upon every change. disabling is unrecommended.
          save_on_change = true,

          -- sets harpoon to run the command immediately as it's passed to the terminal when calling `sendCommand`.
          enter_on_sendcmd = false,

          -- closes any tmux windows harpoon that harpoon creates when you close Neovim.
          tmux_autoclose_windows = false,

          -- filetypes that you want to prevent from adding to the harpoon list menu.
          excluded_filetypes = { "harpoon" },

          -- set marks specific to each git branch inside git repository
          mark_branch = false,

          -- enable tabline with harpoon marks
          tabline = false,
          tabline_prefix = "   ",
          tabline_suffix = "   ",
        }
      })

      require('persistence.nvim').setup( {
        dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"), -- directory where session files are saved
        options = { "buffers", "curdir", "tabpages", "winsize" }, -- sessionoptions used for saving
        pre_save = nil, -- a function to call before saving the session
        save_empty = false, -- don't save if there are no open file buffers 
      })

      require('rainbow-delimiters').setup()

      require('nvim-tree').setup()
      -- pcall(require('nvim-treesitter.install').update({ with_sync = true }))

      require('lsp-inlayhints').setup()

      require('gitsigns').setup({
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        }
      })

      require('rust-tools').setup({
        tools = {
          inlay_hints = {
            auto = false,
          },
        },
      })

      require('crates').setup()

      require('nvim-ts-autotag').setup({
        enable_close_on_slash = false,
        enable_close = false,
        filetypes = {
          'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue', 'tsx', 'jsx',
          'rescript', 'xml', 'php', 'markdown', 'astro', 'glimmer', 'handlebars', 'hbs', 'twig', 'htmldjango'
        },
      })

      require('tailwindcss-colors').setup()
      
      require('go').setup()


      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        background = {     -- :h background
          light = "latte",
          dark = "mocha",
        },
        transparent_background = true, -- disables setting the background color.
        show_end_of_buffer = false,    -- shows the '~' characters after the end of buffers
        term_colors = false,           -- sets terminal colors (e.g. `g:terminal_color_0`)
        dim_inactive = {
          enabled = true,              -- dims the background color of inactive window
          shade = "dark",
          percentage = 0.15,           -- percentage of the shade to apply to the inactive window
        },
        no_italic = false,             -- Force no italic
        no_bold = false,               -- Force no bold
        no_underline = false,          -- Force no underline
        styles = {                     -- Handles the styles of general hi groups (see `:h highlight-args`):
          comments = { "italic" },     -- Change the style of comments
          conditionals = { "italic" },
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
        },
        color_overrides = {},
        custom_highlights = {},
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          notify = false,
          mini = {
            enabled = true,
            indentscope_color = "",
          },
          -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
        },
      })

      require('todo-comments').setup()

      require('lint').linters.flake8 = {
        cmd = "pflake8"
      }
      require('lint').linters_by_ft = {
        python = {
          'flake8', 'mypy', 'vulture'
        },
        css = {
          'stylelint'
        },
        php = {
          'phpcs',
        },
        htmldjango = {
          'djlint', 'curlylint'
        },
        json = {
          'jsonlint',
        },
        markdown = {
          'vale',
        },
        sql = {
          'sqlfluff',
        },
        -- javascript = {
        --   'eslint_d',
        -- },
        -- typescript = {
        --   'eslint_d',
        -- }
      }

      require('formatter').setup({
        -- Enable or disable logging
        logging = true,
        -- Set the log level
        log_level = vim.log.levels.WARN,
        filetype = {
          javascript = {
            require('formatter.filetypes.javascript').prettier,
          },
          javascriptreact = {
            require('formatter.filetypes.javascript').prettier,
          },
          typescript = {
            require('formatter.filetypes.typescript').prettier,
          },
          typescriptreact = {
            require('formatter.filetypes.typescript').prettier,
          },
          python = {
            require('formatter.filetypes.python').black,
            require('formatter.filetypes.python').isort,
          },
          json = {
            require('formatter.filetypes.json').prettier,
          },
          astro = {
            require('formatter.filetypes.javascript').prettier,
          },
          vue = {
            require('formatter.filetypes.vue').prettier,
          },
          svelte = {
            require('formatter.filetypes.javascript').prettier,
          },
          html = {
            require('formatter.filetypes.html').prettier,
          },
          markdown = {
            require('formatter.filetypes.markdown').prettier,
          },
          php = {
            require('formatter.filetypes.php').php_cs_fixer,
          },
          htmldjango = {
            function()
              return {
                exe = "djlint",
                args = {
                  "--reformat",
                  "-"
                },
                stdin = true,
              }
            end
          },
        },
      })

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


      -- autoformat from formatter.nvim
      local format_group = vim.api.nvim_create_augroup("FormatAutogroup", { clear = true })
      vim.api.nvim_create_autocmd('BufWritePost', {
        group = format_group,
        pattern = '*',
        callback = function()
          vim.cmd('FormatWriteLock')
        end
      })

      -- PLUGIN SETUP
      require('telescope').setup({
        defaults = {
          mappings = {
            i = {
              ['<C-u>'] = false,
              ['<c-d>'] = require('telescope.actions').delete_buffer,
            },
            n = {
              ['<c-d>'] = require('telescope.actions').delete_buffer,
            },
          },
        },
      })
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'file_browser')
      pcall(require('telescope').load_extension, 'harpoon')

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
        ['<C-k>'] = { '<cmd>TmuxNavigateUp<cr>', 'Window Up' },
        ['<C-j>'] = { '<cmd>TmuxNavigateDown<cr>', 'Window Down' },
        ['<C-h>'] = { '<cmd>TmuxNavigateLeft<cr>', 'Window Left' },
        ['<C-l>'] = { '<cmd>TmuxNavigateRight<cr>', 'Window Right' },
        ['<C-\\>'] = { '<cmd>TmuxNavigatePrevious<cr>', 'Window Right' },
      }, { mode = 'n' })

      wk.register({
        -- close buffer
        b = {
          name = "+Buffer",
          c = { '<cmd>bp<bar>sp<bar>bn<bar>bd<CR>', 'Close current buffer' },
        },
        -- SEARCH AND TELESCOPE KEYBINDS
        s = {
          name = "+Search",
          f = { function() require('telescope.builtin').find_files() end, "Search Files" },
          w = { function() require('telescope.builtin').grep_string() end, "Search current word" },
          g = { function() require('telescope.builtin').live_grep() end, "Search with grep" },
          d = { function() require('telescope.builtin').diagnostics() end, "Search Diagnostics" },
          b = { '<cmd>Telescope file_browser<cr>', 'Open Telescope File Browser' },
          h = { '<cmd>Telescope harpoon marks<cr>', 'Harpoon Marks' },
          t = { '<cmd>TodoTelescope<cr>', 'Search Todos' },
        },
        f = { f = { '<cmd>Format<cr>', 'Format file' } },
        -- harpoon keybinds
        h = {
          name = "+Harpoon",
          a = { require("harpoon.mark").add_file, 'Add file to harpoon' },
          n = { require("harpoon.ui").nav_next, 'Next harpoon file' },
          p = { require("harpoon.ui").nav_prev, 'Previous harpoon file' },
        },
        -- Session keybinds
        q = {
          name = "+Session",
          s = { function() require('persistence').load() end, "Load Session for Directory" },
          l = { function() require('persistence').load({ last = true }) end, "Load Last Session" },
          d = { function() require('persistence').top() end, "Don't save session" },
        },
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
        highlight = { enable = true },
        indent = { enable = true, },
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

        -- wk.register({
        --   ['<C-k>'] = { function() vim.lsp.buf.signature_help() end, "Signature Documentation" },
        -- }, { mode = 'n' })

        vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
          vim.lsp.buf.format()
        end, { desc = 'Format current buffer with LSP' })
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
      vim.api.nvim_create_autocmd("LspAttach", {
        group = "LspAttach_inlayhints",
        callback = function(args)
          if not (args.data and args.data.client_id) then
            return
          end

          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          require("lsp-inlayhints").on_attach(client, bufnr)
        end,
      })

      -- LSP Server Setup
      local servers = {
        lua_ls = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            diagnostics = {
              globals = { 'vim' },
            },
          },
        },
        gopls = {},
        rust_analyzer = {},
        svelte = {},
        astro = {},
        eslint = {},
        pyright = {},
        spellcheck = {},
        tailwindcss = {
          capabilities = capabilities,
          init_options = {
            userLanguages = {
              htmldjango = "html",
              twig = "html",
              php = "html",
            },
          }
        },
        intelephense = {
          capabilities = capabilities,
          intelephense = {
            stubs = {
              "bcmath",
              "bz2",
              "calendar",
              "Core",
              "curl",
              "zip",
              "zlib",
              "wordpress",
              "woocommerce",
              "acf-pro",
              "wordpress-globals",
              "wp-cli",
              "genesis",
              "polylang",
            },
            environment = {
              includePaths = "~/.composer/vendor/php-stubs",
            },
            files = {
              maxSize = 5000000,
            },
          },
        }
      }

      require('neodev').setup()
      require('mason').setup()

      local mason_lspconfig = require('mason-lspconfig')

      mason_lspconfig.setup({ ensure_installed = vim.tbl_keys(servers), })

      mason_lspconfig.setup_handlers({
        function(server_name)
          local attach_function = on_attach
          if server_name == "tailwindcss" then
            attach_function = function(client, bufnr)
              on_attach(client, bufnr)
              require('tailwindcss-colors').buf_attach(bufnr)
            end
          end
          require('lspconfig')[server_name].setup({
            capabilities = capabilities,
            on_attach = attach_function,
            settings = servers[server_name],
          })
        end,
      })

      require("typescript-tools").setup {
        on_attach = on_attach,
        settings = {
          -- spawn additional tsserver instance to calculate diagnostics on it
          separate_diagnostic_server = true,
          -- "change"|"insert_leave" determine when the client asks the server about diagnostic
          publish_diagnostic_on = "insert_leave",
          -- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
          -- "remove_unused_imports"|"organize_imports") -- or string "all"
          -- to include all supported code actions
          -- specify commands exposed as code_actions
          expose_as_code_action = "all",
          -- string|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
          -- not exists then standard path resolution strategy is applied
          tsserver_path = "${pkgs.nodePackages.typescript-language-server}/lib/node_modules/typescript/lib/tsserver.js",
          -- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
          -- (see 💅 `styled-components` support section)
          tsserver_plugins = {},
          -- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
          -- memory limit in megabytes or "auto"(basically no limit)
          tsserver_max_memory = "auto",
          -- described below
          tsserver_format_options = {},
          tsserver_file_preferences = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayVariableTypeHintsWhenTypeMatchesName = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
          -- locale of all tsserver messages, supported locales you can find here:
          -- https://github.com/microsoft/typescript/blob/3c221fc086be52b19801f6e8d82596d04607ede6/src/compiler/utilitiespublic.ts#l620
          tsserver_locale = "en",
          -- mirror of vscode's `typescript.suggest.completefunctioncalls`
          complete_function_calls = false,
          include_completions_with_insert_text = true,
          -- codelens
          -- warning: experimental feature also in vscode, because it might hit performance of server.
          -- possible values: ("off"|"all"|"implementations_only"|"references_only")
          code_lens = "off",
          -- by default code lenses are displayed on all referencable values and for some of you it can
          -- be too much this option reduce count of them by removing member references from lenses
          disable_member_code_lens = true,
        },
      }

      -- COMPLETION SETUP
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      luasnip.config.setup({
        history = true,
        ext_base_prio = 100,
        ext_prio_increase = 1,
        enable_autosnippets = true,
      })

      luasnip.filetype_extend("python", {
        "django"
      })

      luasnip.filetype_extend("html", {
        "htmldjango"
      })

      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end
        },
        window = {
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
          { name = 'luasnip',  max_item_count = 3 },
          { name = 'buffer',   max_item_count = 2 },
          { name = 'rg',       max_item_count = 1 }
        },
        formatting = {
          format = require('lspkind').cmp_format({
            mode = 'symbol_text',
            maxwidth = 50,
            ellipsis_char = '...'
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
        "nix", "lua", "astro", "py",
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

      vim.cmd.colorscheme('catppuccin')
      -- lilypond configuration
      vim.api.nvim_create_autocmd('BufEnter', {
        command = "syntax sync fromstart",
        pattern = { '*.ly', '*.ily', '*.tex' }
      })



      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufRead' }, {
        command = "lua require('nvls').setup()",
        pattern = { '*.ly', '*.ily', '*.tex' },
      })

    '';
  };
}
