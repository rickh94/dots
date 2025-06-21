{ ... }:
{
  programs.nixvim = {
    enable = true;
    colorschemes.catppuccin = {
      enable = true;
      flavour = "macchiato";
    };

    plugins = {
      lualine.enable = true;
    };
  };
}
