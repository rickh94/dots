{ pkgs }:
{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      telescope-nvim
      telescope-fzf-native-nvim
      telescope-file-browser-nvim
    ];

    extraLuaConfig = /* lua */ ''
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

      require('which-key').register({
        -- SEARCH AND TELESCOPE KEYBINDS
        s = {
          name = "+Search",
          f = { function() require('telescope.builtin').find_files() end, "Search Files" },
          w = { function() require('telescope.builtin').grep_string() end, "Search current word" },
          g = { function() require('telescope.builtin').live_grep() end, "Search with grep" },
          d = { function() require('telescope.builtin').diagnostics() end, "Search Diagnostics" },
          b = { '<cmd>Telescope file_browser<cr>', 'Open Telescope File Browser' },
        },
        ['?'] = { function() require("telescope.builtin").oldfiles() end, "Recent files" },
        ['<Space>'] = { function() require('telescope.builtin').buffers() end, "Open files" },
        ['/'] = { function()
          require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
          })
        end, "Fuzzy search buffer" },
      }, { prefix = '<leader>', mode = 'n' })


    '';
    # move todo telescope to other file

  };
}
