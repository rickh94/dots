{ unstablePkgs, ... }: {
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
  ];
  programs.nixvim.plugins.lint = {

    lintersByFt = {
      css = [ "stylelint" ];
      htmldjango = [ "djlint" "codespell" ];
      json = [ "jsonlint" ];
      sql = [ "sqlfluff" ];
      html = [ "codespell" ];
      markdown = [ "codespell" ];
      txt = [ "codespell" ];
    };
  };
}
