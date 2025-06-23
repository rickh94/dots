{ ...
}: {
  programs.nixvim.plugins = {
    luasnip.enable = true;
    blink-cmp = {
      enable = true;
      settings.sources.default = [
        "ripgrep"
        "path"
        "buffer"
        "lsp"
      ];
      settings.keymap.preset = "enter";
      settings.sources.providers = {
        ripgrep = {
          async = true;
          module = "blink-ripgrep";
          name = "Ripgrep";
          score_offset = 100;
          opts = {
            prefix_min_len = 3;
            context_size = 5;
            max_filesize = "1M";
            project_root_marker = ".git";
            project_root_fallback = true;
            search_casing = "--ignore-case";
            additional_rg_options = { };
            fallback_to_regex_highlighting = true;
            ignore_paths = { };
            additional_paths = { };
            debug = false;
          };
        };
      };
    };
    blink-ripgrep.enable = true;
  };

}
