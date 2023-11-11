{ pkgs, lib, ... }:
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
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      mason-nvim
      mason-lspconfig-nvim
      neodev-nvim
      lspkind-nvim
      lsp-inlayhints-nvim
      (plugin "pmizio/typescript-tools.nvim")
    ];

    extraPackages = with pkgs; [
      gopls
      nodePackages.pyright
      rust-analyzer
      nodePackages.typescript
      nodePackages.typescript-language-server
      nil
      isort
      mypy
      pylint
      ruff
      black
      lua-language-server
      nodePackages.svelte-language-server
      nodePackages.intelephense
      nodePackages.vscode-langservers-extracted
      nodePackages.pyright
      nodePackages.prettier
      nodePackages.eslint
      nodePackages.stylelint
      nodePackages.jsonlint
    ];

    extraLuaConfig = /* lua */ ''
      require('lsp-inlayhints').setup()
      require('mason').setup()
      require('neodev').setup()

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
    '';

  };
}
