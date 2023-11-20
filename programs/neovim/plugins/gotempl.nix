{ unstablePkgs
, codeium-lsp
, ...
}:
let
  tree-sitter-templ = unstablePkgs.vimUtils.buildVimPlugin {
    pname = "tree-sitter-templ";
    version = "HEAD";
    src = builtins.fetchGit {
      url = "https://github.com/vrischmann/tree-sitter-templ";
      ref = "HEAD";
    };
  };
in
{
  programs.neovim = {
    plugins = [
      tree-sitter-templ
    ];
    extraLuaConfig =
      /*
      lua
      */
      ''
        local treesitter_parser_config = require "nvim-treesitter.parsers".get_parser_configs()

        require("tree-sitter-templ").setup({})
      '';
  };
}
