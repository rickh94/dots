{unstablePkgs, ...}: {
  home.packages = with unstablePkgs; [
    mypy
    stylelint
    nodePackages.jsonlint
    djlint
    yamllint
    write-good
    bandit
    sqlfluff
    codespell
    eslint
  ];
  # add eslint and golang lint ci
  programs.nixvim.plugins.lint = {
    enable = true;

    lintersByFt = {
      css = ["stylelint"];
      htmldjango = ["djlint" "codespell"];
      json = ["jsonlint"];
      sql = ["sqlfluff"];
      html = ["codespell"];
      markdown = ["codespell"];
      txt = ["codespell"];
    };
  };
}
