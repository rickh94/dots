{ pkgs, codeium-lsp, ... }:
let
  codeium-patched = pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "codeium.vim";
    version = "HEAD";
    src = builtins.fetchGit {
      url = "https://github.com/Exafunction/codeium.vim";
      ref = "HEAD";
    };
    postInstall =
      ''
        sed -i "/call mkdir(manager_dir, 'p')/ a\\
          let s:bin = \"${codeium-lsp}/bin/codeium-lsp\"" $target/autoload/codeium/server.vim
      '';
  };
in
{

  programs.neovim = {
    plugins = [
      codeium-patched
    ];
    extraPackages = [
      codeium-lsp
    ];
    extraLuaConfig = /* lua */ ''
      vim.keymap.set('i', '<C-g>', function() return vim.fn['codeium#Accept']() end, { expr = true })
    '';
  };
}
