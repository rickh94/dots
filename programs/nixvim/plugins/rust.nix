{ pkgs, ... }: {
  programs.nixvim = {
    globals.rustaceanvim.    plugins.rustaceanvim = {
      enable = true;
      settings = {
        server = {
          on_attach = {
            _raw = /* lua */ ''
              function(client, bufnr)
                vim.keymap.set("n", "<leader>a", function() vim.cmd.RustLsp('codeAction') end, {silent = true, buffer = bufnr})
                vim.keymap.set("n", "K", function() vim.cmd.RustLsp({'hover', 'actions}) end, { silent = true, buffer = bufnr})
                vim.keymap.set("n", "<leader>r", function() vim.lsp.buf.rename() end)
                vim.keymap.set("n", "<leader>z", function() vim.lsp.buf.code_action() end)
                vim.keymap.set("n", "<leader>D", function() vim.lsp.buf.type_definition() end)
                vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end)
                vim.keymap.set("n", "gr", function() require("telescope.builtin").lsp_references() end)
                vim.keymap.set("n", "gI", function() vim.lsp.buf.implementation() end)
                vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end)
                vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end)
                vim.keymap.set("n", "<A-k>", function() vim.lsp.buf.signature_help() end)

                if client.server_capabilities.documentSymbolProvider then
                  require('nvim-navic').attach(client, bufnr)
                end

                vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_) vim.lsp.buf.format() end, {})
              end
            '';
          };
          default_settings = {
            "rust-analyzer" = {
              procMacro = {
                ignored = {
                  leptos_macro = [ "server" ];
                };
              };
              checkOnSave = {
                command = "clippy";
                enable = true;
              };
              diagnostics.enable = true;
            };
          };
        };

      };
    };
  };
}
