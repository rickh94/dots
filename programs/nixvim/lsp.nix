{ pkgs, ... }:
{
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      lsp_signature-nvim
      lspkind-nvim
      (pkgs.vimUtils.buildVimPlugin {
        pname = "lsp-endhints";
        version = "2025-06-21";
        src = pkgs.fetchFromGitHub {
          owner = "chrisgrieser";
          repo = "nvim-lsp-endhints";
          rev = "7917c7af1ec345ca9b33e8dbcd3723fc15d023c0";
          sha256 = "sha256-ZssCVWm7/4U7oAsEXB1JgLoSzcdAjXsO2wEDyS40/SQ=";
        };
      })
    ];

    plugins.navic.enable = true;

    extraConfigLua = /* lua */ ''
      require('lsp-endhints').setup()
      require('lsp_signature').setup()
      require('lspkind').setup()
    '';


    # plugins.lspconfig = {
    #   enable = true;
    # };

    lsp = {
      onAttach = /* lua */ ''
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
      '';
      servers = {
        arduino_language_server.enable = true;
        astro.enable = true;
        clangd.enable = true;
        docker_compose_language_service.enable = true;
        dockerls.enable = true;
        elixirls.enable = true;
        eslint.enable = true;
        fish_lsp.enable = true;
        golangci_lint_ls.enable = true;
        gopls.enable = true;
        html.enable = true;
        htmx.enable = true;
        jsonls.enable = true;
        just.enable = true;
        lua_ls = {
          enable = true;
          settings = {
            Lua = {
              workspace = { checkThirdParty = false; };
              telemetry = { enable = false; };
              diagnostics = { globals = [ "vim" ]; };
            };
          };
        };
        nil_ls.enable = true;
        pyright.enable = true;
        svelte.enable = true;
        ts_ls = {
          enable = true;
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all";
                includeInlayParameterNameHintsWhenArgumentMatchesName = true;
                includeInlayVariableTypeHints = true;
                includeInlayFunctionParameterTypeHints = true;
                includeInlayVariableTypeHintsWhenTypeMatchesName = true;
                includeInlayPropertyDeclarationTypeHints = true;
                includeInlayFunctionLikeReturnTypeHints = true;
                includeInlayEnumMemberValueHints = true;
              };
            };
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all";
                includeInlayParameterNameHintsWhenArgumentMatchesName = true;
                includeInlayVariableTypeHints = true;
                includeInlayFunctionParameterTypeHints = true;
                includeInlayVariableTypeHintsWhenTypeMatchesName = true;
                includeInlayPropertyDeclarationTypeHints = true;
                includeInlayFunctionLikeReturnTypeHints = true;
                includeInlayEnumMemberValueHints = true;
              };
            };
          };
        };
        zls.enable = true;
      };
    };
  };
}
