{...}: {
  programs.helix.enable = true;
  programs.helix.settings = {
    theme = "catppuccin_macchiato";
    editor = {
      line-number = "relative";
      cursorline = true;
      lsp = {
        display-inlay-hints = true;
      };
      cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
      };
      indent-guides.render = true;
      inline-diagnostics = {
        cursor-line = "error";
        other-lines = "error";
      };
    };
  };
}
