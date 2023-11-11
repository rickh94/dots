{ unstablePkgs, ... }:
{
  programs.neovim = {
    plugins = with unstablePkgs.vimPlugins; [
      ChatGPT-nvim
    ];

    extraLuaConfig = /* lua */ ''
      require("chatgpt").setup({
          api_key_cmd = "pass show openai/nvim"
      })
    '';

  };
}
