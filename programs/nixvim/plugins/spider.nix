{ ... }: {
  programs.nixvim.plugins.spider = {
    keymaps.motions = {
      b = "b";
      e = "e";
      ge = "ge";
      w = "w";
    };
    enable = true;
  };
}
