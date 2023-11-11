{ pkgs }:
{
  programs.neovim = {
    plugins = [
      codeium-vim
    ];
    extraLuaConfig = /* lua */ ''

      vim.keymap.set('i', '<C-g>', function() return vim.fn['codeium#Accept']() end, { expr = true })
    '';
  };
}
