{ unstablePkgs
, config
, pkgs
, ...
}: {
  home.packages = with unstablePkgs; [
    alejandra
    black
    djlint
    isort
    nodePackages.prettier
    rustywind
    taplo
    python312Packages.mdformat
    stylelint
    yamlfmt
    gawk
    sqlfluff
  ];
  programs.nixvim.plugins.conform-nvim = {
    enable = true;
    settings = {
      format_on_save = {
        timeout_ms = 500;
        lsp_fallback = true;
      };
      format_after_save = {
        lsp_fallback = true;
      };
      formatters = {
        isort = {
          prepend_args = [ "--profile" "black" ];
        };
      };
      formatters_by_ft = {
        nix = [ "alejandra" ];
        python = [ "black" "isort" ];
        htmldjango = [ "djlint" "rustywind" ];
        jinja = [ "djlint" "rustywind" ];
        twig = [ "djlint" "rustywind" ];
        fish = [ "fish_indent" ];
        yaml = [ "yamlfmt" ];
        javascript = [ "prettier" "rustywind" ];
        typescript = [ "prettier" "rustywind" ];
        javascriptreact = [ "prettier" "rustywind" ];
        typescriptreact = [ "prettier" "rustywind" ];
        astro = [ "prettier" "rustywind" ];
        markdown = [ "prettier" "rustywind" ];
        html = [ "prettier" "rustywind" ];
        css = [ "prettier" ];
        toml = [ "taplo" ];
        "*" = [ "trim_whitespace" ];
      };
    };
  };
  programs.nixvim.keymaps = [
    {
      action = "<cmd>Format<cr>";
      key = "<leader>f";
      mode = [ "n" ];
    }
  ];
}
