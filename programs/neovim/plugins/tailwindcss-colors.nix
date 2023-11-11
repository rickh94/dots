{pkgs, ... }:
let
  pluginGit = ref: repo: pkgs.vimUtils.buildVimPluginFrom2Nix {
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
    plugins = with pkgs.vimPlugins; [
      (plugin "themaxmarchuk/tailwindcss-colors.nvim")
    ];

    extraLuaConfig = /* lua */ ''
      require('tailwindcss-colors').setup()
    '';

  };
}
