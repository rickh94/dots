{ unstablePkgs, ... }: {
  programs.neovim = {
    plugins = with unstablePkgs.vimPlugins; [
      telescope-nvim
      telescope-fzf-native-nvim
      telescope-file-browser-nvim
    ];

    extraLuaConfig =
      /*
      lua
      */
      ''
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

        require('which-key').add({
          mode = 'n',
          { '<leader>sf', function() require('telescope.builtin').find_files() end, desc = "Search Files"},
          { '<leader>sw', function() require('telescope.builtin').grep_string() end, desc = "Search Grep String"},
          { '<leader>sg', function() require('telescope.builtin').live_grep() end, desc = "Search with grep"},
          { '<leader>sd', function() require('telescope.builtin').diagnostics() end, desc = "Search Diagnostics"},
          { '<leader>?', function() require("telescope.builtin").oldfiles() end, desc = "Recent files"},
          { '<leader><Space>', function() require("telescope.builtin").buffers() end, desc = "Open Files"},
          { '<leader>/', function() require("telescope.builtin").current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false
          }) end, desc = "Fuzzy search buffer"},
          })


      '';
    # move todo telescope to other file
  };
}
