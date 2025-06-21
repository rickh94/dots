{ unstablePkgs, ... }:
{
  programs.neovim = {
    plugins = [
      unstablePkgs.vimPlugins.rustaceanvim
    ];

    extraLuaConfig =
      /*
        lua
      */
      ''

        vim.g.rustaceanvim = {
          server = {
            on_attach = function(client, bufnr)
              vim.keymap.set(
                "n",
                "<leader>a",
                function()
                  vim.cmd.RustLsp('codeAction') -- supports rust-analyzer's grouping
                  -- or vim.lsp.buf.codeAction() if you don't want grouping.
                end,
                { silent = true, buffer = bufnr }
              )
              vim.keymap.set(
                "n",
                "K",  -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
                function()
                  vim.cmd.RustLsp({'hover', 'actions'})
                end,
                { silent = true, buffer = bufnr }
              )

              require('which-key').add({
                {
                  mode = 'n',
                  group = 'LSP',
                  { '<leader>r', function() vim.lsp.buf.rename() end, desc = "Rename Symbol" },
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


                { '<A-k>', function() vim.lsp.buf.signature_help() end, desc = "Signature Documentation" },
              })

              vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
                vim.lsp.buf.format()
              end, { desc = 'Format current buffer with LSP' })
            end,
            default_settings = {
              ['rust-analyzer'] = {
                procMacro = {
                  ignored = {
                      leptos_macro = {
                          -- optional: --
                          -- "component",
                          "server",
                      },
                  },
                },
                checkOnSave = {
                  command = "clippy",
                  enable = true,
                },
                diagnostics = {
                  enable = true,
                },
              }
            }
          }
        }
        -- require('crates').setup()
      '';
  };
}
