{ pkgs, inputs, system, ... }:
let
  fromGitHub = import ../functions/fromGitHub.nix;
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
      (fromGitHub "HEAD" "hiphish/rainbow-delimiters.nvim")
      (fromGitHub "HEAD" "tmillr/sos.nvim")
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
