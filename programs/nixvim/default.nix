{ ... }:
{
  programs.nixvim = {
    enable = true;
    colorschemes.catppuccin = {
      enable = true;
      flavor = "macchiato";
    };

    plugins = {
      lualine.enable = true;
    };
  };
}
