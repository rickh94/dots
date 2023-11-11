{pkgs, ... }:
{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      go-nvim
    ];

    extraLuaConfig = /* lua */ ''
      require('go').setup()
    '';

  };
}
