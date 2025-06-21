{ ... }:
{
  programs.nixvim = {
    enable = true;
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "macchiato";
      };
    };

    plugins = {
      lualine.enable = true;
    };
  };
}
