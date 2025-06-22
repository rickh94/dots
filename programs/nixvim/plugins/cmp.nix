{ ...
}: {
  programs.nixvim.plugins.cmp = {
    enable = true;
    autoEnableSources = true;
    settings.sources = [
      { name = "nvim_lsp"; max_item_count = 30; }
      { name = "buffer"; max_item_count = 30; }
    ];
  };

}
