{ ... }: {
  programs.nixvim.plugins = {
    friendly-snippets.enable = true;
    cmp = {
      enable = true;
      autoEnableSources = true;
      settings.window = { };
      settings.performance.max_view_entries = 10;
      settings.mapping = {
        "<C-d>" = "cmp.mapping.scroll_docs(-4)";
        "<C-f>" = "cmp.mapping.scroll_docs(4)";
        "<C-e>" = "cmp.mapping.abort()";
        "<C-Space>" = "cmp.mapping.complete({})";
        "<CR>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true, })";
        "<Tab>" = ''
          cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif require('luasnip').expand_or_jumpable() then
              require('luasnip').expand_or_jump()
            else
              fallback()
              end
            end, { 'i', 's' })
        '';
        "<S-Tab>" = ''
          cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif require('luasnip').jumpable(-1) then
              require('luasnip').jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' })

        '';
      };
      settings.formatting.format = ''
        require('lspkind').cmp_format({
          mode = 'symbol_text',
          maxwidth = 50,
          ellipsis_char = '...'
        })
      '';
      settings.sources = [
        {
          name = "nvim_lsp";
          max_item_count = 10;
        }
        {
          name = "luasnip";
          max_item_count = 5;
        }
        {
          name = "rg";
          max_item_count = 3;
        }
        {
          name = "buffer";
          max_item_count = 5;
        }
        {
          name = "path";
          max_item_count = 5;
        }
      ];
      cmdline = {
        "/" = {
          mapping = {
            __raw = "cmp.mapping.preset.cmdline()";
          };
          sources = [
            {
              name = "buffer";
            }
          ];
        };
        ":" = {
          mapping = {
            __raw = "cmp.mapping.preset.cmdline()";
          };
          sources = [
            {
              name = "path";
            }
            {
              name = "cmdline";
              option = {
                ignore_cmds = [
                  "Man"
                  "!"
                ];
              };
            }
          ];
        };
      };
    };
  };
}
