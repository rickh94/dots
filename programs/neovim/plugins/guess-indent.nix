{ pkgs }:
{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      guess-indent-nvim
    ];

    extraLuaConfig = /* lua */ ''
      require('guess-indent').setup {}
    '';

  };
}
