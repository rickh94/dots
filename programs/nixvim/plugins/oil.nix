{ ... }: {
  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "-";
      action = "<cmd>Oil<cr>";
    }
  ];

  programs.nixvim.plugins.oil-git-status.enable = true;

  programs.nixvim.plugins.oil = {
    enable = true;
    settings = {
      default_file_explorer = true;
      colums = [ "icon" ];
      buf_options = {
        buflisted = false;
        bufhidden = "hide";
      };
      win_options = {
        wrap = false;
        signcolumn = "yes:2";
        cursorcolumn = false;
        spell = false;
        list = false;
        conceallevel = 3;
        concealcursor = "nvic";
      };
      delete_to_trash = true;
      skip_confirm_for_simple_edits = false;
      prompt_save_on_select_new_entry = true;
      cleanup_delay_ms = 2000;
      keymaps = {
        "g?" = "actions.show_help";
        "<CR>" = "actions.select";
        "<C-t>" = "actions.select_tab";
        "<C-p>" = "actions.preview";
        "<C-c>" = "actions.close";
        "-" = "actions.parent";
        "_" = "actions.open_cwd";
        "`" = "actions.cd";
        "~" = "actions.tcd";
        "gs" = "actions.change_sort";
        "gx" = "actions.open_external";
        "g." = "actions.toggle_hidden";
        "g\\" = "actions.toggle_trash";
      };
      use_default_keymaps = false;
      view_options = {
        show_hidden = false;
        is_hidden_file = /* lua */ ''
          function(name, bufnr)
            return vim.startswith(name, ".")
          end
        '';
        is_always_hidden = /* lua */ ''
          function(name, bufnr)
            return false
          end
        '';
        sort = [
          [ "type" "asc" ]
          [ "name" "asc" ]
        ];
      };
    };
  };
}
