{ unstablePkgs, lib, ... }:
let
  pluginGit = ref: repo: unstablePkgs.vimUtils.buildVimPluginFrom2Nix {
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
    plugins = with unstablePkgs.vimPlugins; [
      (plugin "hiphish/rainbow-delimiters.nvim")
    ];

    extraLuaConfig = /* lua */ ''
      require('rainbow-delimiters.setup').setup()
    '';

  };
}
