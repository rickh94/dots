{ unstablePkgs, pkgs, ... }:
let
  nvim-lsp-endhints = unstablePkgs.vimUtils.buildVimPlugin {
    pname = "nvim-lsp-endhints";
    version = "HEAD";
    src = builtins.fetchGit {
      url = "https://github.com/chrisgrieser/nvim-lsp-endhints";
      ref = "HEAD";
    };
  };
in
{
  programs.neovim = {
    plugins = with unstablePkgs.vimPlugins; [
      nvim-lspconfig
      mason-nvim
      mason-lspconfig-nvim
      lazydev-nvim
      lspkind-nvim
      # lsp-inlayhints-nvim
      # typescript-tools-nvim
      nvim-navic
      nvim-lsp-endhints
      lsp_signature-nvim
    ];

    extraPackages = with unstablePkgs; [
      unstablePkgs.openscad-lsp
      gopls
      # rust-analyzer
      nodePackages.typescript
      nodePackages.typescript-language-server
      nil
      isort
      mypy
      # ruff
      black
      lua-language-server
      nodePackages.svelte-language-server
      nodePackages.intelephense
      nodePackages.vscode-langservers-extracted
      nodePackages.prettier
      nodePackages.eslint
      nodePackages.stylelint
      nodePackages.jsonlint
      # python312Packages.jedi
      # python312Packages.rope
      # python312Packages.pyflakes
      # python312Packages.pycodestyle
      # python312Packages.mccabe
      # python312Packages.python-lsp-server
      # python312Packages.pylsp-rope
      # python312Packages.pylsp-mypy
      # python312Packages.python-lsp-black
      # python312Packages.pyls-isort
      # python312Packages.pyls-flake8
      # python312Packages.python-lsp-ruff
      coreutils-full
      wget
      gnutar
      gzip
      arduino-cli
      clang
    ];

    extraLuaConfig =
      /*
      lua
      */
      ''
        require("lsp-endhints").setup()
        require('mason').setup()

        local navic = require("nvim-navic")
        navic.setup()

        -- LSP CONFIGURATION
        local on_attach = function(client, bufnr)
          -- LSP Keybindings
          wk.add({
          {
            mode = 'n',
            group = 'LSP',
            { '<leader>r', function() vim.lsp.buf.rename() end, desc = "Rename Symbol" },
            { '<leader>a',  function() vim.lsp.buf.code_action() end, desc = "Code Action" },
            { '<leader>D', function() vim.lsp.buf.type_definition() end, desc = "Type Definition" },
          },

          {
            mode = 'n',
            group = 'LSP',
            { 'gd', function() vim.lsp.buf.definition() end, desc = "Goto Definition" },
            { 'gr', function() require('telescope.builtin').lsp_references() end, desc = "Goto References" },
            { 'gI', function() vim.lsp.buf.implementation() end, desc = "Goto Implementation" },
            { 'gD', function() vim.lsp.buf.declaration() end, desc = "Goto Declaration" },
          },

          { 'K', function() vim.lsp.buf.hover() end, desc = "Hover Documentation" },

          { '<A-k>', function() vim.lsp.buf.signature_help() end, desc = "Signature Documentation" },
          })

          if client.server_capabilities.documentSymbolProvider then
              navic.attach(client, bufnr)
          end

          vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
            vim.lsp.buf.format()
          end, { desc = 'Format current buffer with LSP' })
        end

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

        -- vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
        -- vim.api.nvim_create_autocmd("LspAttach", {
        --   group = "LspAttach_inlayhints",
        --   callback = function(args)
        --     if not (args.data and args.data.client_id) then
        --       return
        --     end
        --
        --     local bufnr = args.buf
        --     local client = vim.lsp.get_client_by_id(args.data.client_id)
        --     require("lsp-inlayhints").on_attach(client, bufnr)
        --   end,
        -- })

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
          -- rust_analyzer = {},
          svelte = {},
          astro = {},
          eslint = {},
          pyright = {},
          -- pylsp = {
          --   plugins = {
          --     pyflakes = { enabled = false },
          --     pycodestyle = { enabled = false },
          --     flake8 = { enabled = true },
          --     black = { enabled = true },
          --     -- linter options
          --     -- type checker
          --     pylsp_mypy = { enabled = true },
          --     -- auto-completion options
          --     jedi_completion = { fuzzy = true },
          --     -- import sorting
          --     pyls_isort = { enabled = true },
          --     ruff = { enabled = true },
          --     rope = { enabled = true, },
          --     rope_autoimport = {
          --       enabled = true,
          --       code_action = {
          --         enabled = true,
          --       },
          --     },
          --   },
          -- },
          -- arduino_language_server = {
          --   cmd = {
          --     "arduino-language-server",
          --     "-cli-config", "/Users/rick/Library/Arduino15/arduino-cli.yaml",
          --     "-cli", "${unstablePkgs.arduino-cli}/bin/arduino-cli",
          --     "-clangd", "${unstablePkgs.clang}/bin/clangd"
          --   }
          -- },
          -- rust_analyzer = {
          --   checkOnSave = {
          --       -- command = "clippy",
          --     enable = false,
          --   },
          --   diagnostics = {
          --     enable = false,
          --   },
          -- },
          ts_ls = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all'
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayVariableTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all'
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayVariableTypeHints = true,

                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
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
        local tw_filetypes = {
          "aspnetcorerazor",
          "astro",
          "astro-markdown",
          "blade",
          "clojure",
          "django-html",
          "htmldjango",
          "edge",
          "eelixir",
          "elixir",
          "ejs",
          "erb",
          "eruby",
          "gohtml",
          "gohtmltmpl",
          "haml",
          "handlebars",
          "hbs",
          "html",
          "html-eex",
          "heex",
          "jade",
          "leaf",
          "liquid",
          "markdown",
          "mdx",
          "mustache",
          "njk",
          "nunjucks",
          "php",
          "razor",
          "slim",
          "twig",
          "css",
          "less",
          "postcss",
          "sass",
          "scss",
          "stylus",
          "sugarss",
          "javascript",
          "javascriptreact",
          "reason",
          "rescript",
          "typescript",
          "typescriptreact",
          "vue",
          "svelte",
          "templ",
        }

        local mason_lspconfig = require('mason-lspconfig')

        mason_lspconfig.setup({ ensure_installed = vim.tbl_keys(servers), })

        for i = 1, #servers do
          local server_name = servers[i]
          require('lspconfig')[server_name].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
          })
        end

        require('lspconfig').openscad_lsp.setup({
          cmd =  { "${unstablePkgs.openscad-lsp}/bin/openscad-lsp", "--stdio" },
          on_attach = on_attach,
          capabilities = capabilities,
        })

        -- require('tailwindcss-colors').setup()
        require('lspconfig').tailwindcss.setup({
          capabilities = capabilities,
          settings = {
            tailwindCSS = {
              classAttributes = { "class", "className", "class:list", "classList", "ngClass" },
              lint = {
                cssConflict = "warning",
                invalidApply = "error",
                invalidConfigPath = "error",
                invalidScreen = "error",
                invalidTailwindDirective = "error",
                invalidVariant = "error",
                recommendedVariantOrder = "warning"
              },
              validate = true
            }
          },
          init_options = {
            userLanguages = {
              templ = "html"
            },
          },
          filetypes = tw_filetypes,
        })
        -- require('lspconfig').bacon_ls.setup({
        --   init_options = {
        --     updateOnSave = true,
        --     updateOnSaveWaitMillis = 1000,
        --     updateOnChange = false,
        --   },
        -- })

        -- require("typescript-tools").setup {
        --   on_attach = on_attach,
        --   settings = {
        --     -- spawn additional tsserver instance to calculate diagnostics on it
        --     separate_diagnostic_server = true,
        --     -- "change"|"insert_leave" determine when the client asks the server about diagnostic
        --     publish_diagnostic_on = "insert_leave",
        --     -- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
        --     -- "remove_unused_imports"|"organize_imports") -- or string "all"
        --     -- to include all supported code actions
        --     -- specify commands exposed as code_actions
        --     expose_as_code_action = "all",
        --     -- string|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
        --     -- not exists then standard path resolution strategy is applied
        --     --tsserver_path = "${unstablePkgs.nodePackages.typescript-language-server}/lib/node_modules/typescript/lib/tsserver.js",
        --     tsserver_path = nil,
        --     -- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
        --     -- (see 💅 `styled-components` support section)
        --     tsserver_plugins = {},
        --     -- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
        --     -- memory limit in megabytes or "auto"(basically no limit)
        --     tsserver_max_memory = "auto",
        --     -- described below
        --     tsserver_format_options = {},
        --     tsserver_file_preferences = {
        --       includeInlayParameterNameHints = "all",
        --       includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        --       includeInlayFunctionParameterTypeHints = true,
        --       includeInlayVariableTypeHints = true,
        --       includeInlayVariableTypeHintsWhenTypeMatchesName = true,
        --       includeInlayPropertyDeclarationTypeHints = true,
        --       includeInlayFunctionLikeReturnTypeHints = true,
        --       includeInlayEnumMemberValueHints = true,
        --     },
        --     -- locale of all tsserver messages, supported locales you can find here:
        --     -- https://github.com/microsoft/typescript/blob/3c221fc086be52b19801f6e8d82596d04607ede6/src/compiler/utilitiespublic.ts#l620
        --     tsserver_locale = "en",
        --     -- mirror of vscode's `typescript.suggest.completefunctioncalls`
        --     complete_function_calls = false,
        --     include_completions_with_insert_text = true,
        --     -- codelens
        --     -- warning: experimental feature also in vscode, because it might hit performance of server.
        --     -- possible values: ("off"|"all"|"implementations_only"|"references_only")
        --     code_lens = "off",
        --     -- by default code lenses are displayed on all referencable values and for some of you it can
        --     -- be too much this option reduce count of them by removing member references from lenses
        --     disable_member_code_lens = true,
        --   },
        -- }

        for _, method in ipairs({ 'textDocument/diagnostic', 'workspace/diagnostic' }) do
            local default_diagnostic_handler = vim.lsp.handlers[method]
            vim.lsp.handlers[method] = function(err, result, context, config)
                if err ~= nil and err.code == -32802 then
                    return
                end
                return default_diagnostic_handler(err, result, context, config)
            end
        end
        require('lsp_signature').setup({})
      '';
  };
}












