{ unstablePkgs, ... }:
{
  programs.neovim = {
    plugins = with unstablePkgs.vimPlugins; [
      nvim-cmp
      cmp-nvim-lsp
      cmp-cmdline
      luasnip
      cmp_luasnip
      cmp-fuzzy-buffer
      cmp-path
      friendly-snippets
    ];

    extraLuaConfig = /* lua */ ''
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
          ['<CR>'] = cmp.mapping.confirm({
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


    '';

  };
}
