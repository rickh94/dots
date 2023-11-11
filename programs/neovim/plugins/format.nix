{ pkgs }:
{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      formatter-nvim
    ];

    extraLuaConfig = /* lua */ ''
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

      -- autoformat from formatter.nvim
      local format_group = vim.api.nvim_create_augroup("FormatAutogroup", { clear = true })
      vim.api.nvim_create_autocmd('BufWritePost', {
        group = format_group,
        pattern = '*',
        callback = function()
          vim.cmd('FormatWriteLock')
        end
      })

      require('which-key').register({
        f = { f = { '<cmd>Format<cr>', 'Format file' } },
        -- harpoon keybinds
      }, { prefix = '<leader>', mode = 'n' })

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
    '';

  };
}
