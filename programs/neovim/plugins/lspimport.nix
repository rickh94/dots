{ unstablePkgs, codeium-lsp, ... }:
let
  lspimport = unstablePkgs.vimUtils.buildVimPlugin {
    pname = "lspimport";
    version = "HEAD";
    src = builtins.fetchGit {
      url = "https://github.com/stevanmilic/nvim-lspimport";
      ref = "HEAD";
    };
  };
in
{

  programs.neovim = {
    plugins = [
      lspimport
    ];
    extraPackages = [
    ];
    extraLuaConfig = /* lua */ ''
      --      vim.keymap.set('n', '<leader>a', require('lspimport').import, { noremap = true })
    '';
  };
}

