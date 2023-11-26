{ pkgs, ... }: {
  home.packages = with pkgs; [
    sqlite
  ];
  home.file.".sqliterc" = {
    text = ''
      .headers on
      .mode column
      PRAGMA foreign_keys = ON
    '';
  };
}
