{pkgs, ... }:
{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      rust-tools-nvim
      crates-nvim
    ];

    extraLuaConfig = /* lua */ ''
      require('rust-tools').setup({
        tools = {
          inlay_hints = {
            auto = false,
          },
        },
      })

      require('crates').setup()

    '';

  };
}
