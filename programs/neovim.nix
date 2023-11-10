{ pkgs, inputs, system, ... }:
let
  pluginGit = ref: repo: vimUtils.buildVimPluginFrom2Nix {
    pname = "${lib.strings.sanitizeDerivationName repo}";
    version = ref;
    src = builtins.fetchGit {
      url = "https://github.com/${repo}.git";
      ref = ref;
    };
  };

  # always installs latest version
  plugin = pluginGit "HEAD";
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimDiffAlias = true;
    pllugins = with pkgs.vimPlugins; [
      guess-indent-nvim
      vim-repeat
      undotree
      (plugin "hiphish/rainbow-delimiters.nvim")
      (plugin "tmillr/sos.nvim")
    ];

    extraPackages = with pkgs;[
      tree-sitter
      nodePackages.typescript
      nodePackages.typescript-tools
      gopls
      nodePackages.pyright
      rust-analyzer
    ];

    extraLuaConfig = ''
      require('sos').setup({
          enabled = true,
          timeout = 20000,
          autowrite = true,
          save_on_cmd = "some",
          save_on_bufleave = false,
          save_on_focuslost = true,
        })
    '';
  };
}
