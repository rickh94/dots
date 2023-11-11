{ pkgs }:
{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      comment-nvim
    ];

    extraLuaConfig = /* lua */ ''
      require('Comment').setup()
    '';

  };
}
