{ config, ... }:
let
  helpers = config.lib.nixvim;
in
{
  programs.nixvim = {
    keymaps = [
      {
        mode = "n";
        key = "<leader>sf";
        action = helpers.utils.mkRaw "function() require('telescope.builtin').find_files() end";
      }
      {
        mode = "n";
        key = "<leader>sg";
        action = helpers.utils.mkRaw "function() require('telescope.builtin').live_grep() end";
      }
      {
        mode = "n";
        key = "<leader>sd";
        action = helpers.utils.mkRaw "function() require('telescope.builtin').diagnostics() end";
      }
      {
        mode = "n";
        key = "<leader><Space>";
        action = helpers.utils.mkRaw "function() require('telescope.builtin').buffers() end";
      }
      {
        mode = "n";
        key = "<leader>st";
        action = "<cmd>TodoTelescope<cr>";
      }
    ];

    plugins.todo-comments.enable = true;

    plugins.telescope = {
      enable = true;
      extensions = { fzf-native.enable = true; };
      settings = {
        defaults = {
          mappings = {
            i = {
              "<C-u>" = false;
              "<C-d>" = {
                _raw = "require('telescope.actions').delete_buffer";
              };
            };
            n = {
              "<C-d>" = {
                _raw = "require('telescope.actions').delete_buffer";
              };
            };
          };
        };
      };
    };
  };
}
