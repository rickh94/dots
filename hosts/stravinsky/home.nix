{ pkgs
, ...
}: {
  imports = [
    ../_common/desktop.nix
    ../_common/mac/home-activation.nix
    ../../programs/wezterm-mac.nix
    ../../programs/ghostty-mac.nix
    ../../programs/neovim/full-default.nix
  ];

  home.stateVersion = "22.11";
  nixpkgs.config.allowUnfree = true;

  home.file.".local/state/redis/.keep" = {
    enable = true;
    text = "";
  };
  home.file."Library/Application Support/org.dystroy.bacon/prefs.toml".text = /* toml */ ''

      [exports.locations]
      auto = false
      path = ".bacon-locations"
      line_format = "{kind} {path}:{line}:{column} {message}"
      [exports.json-report]
      auto = false
      path = "bacon-report.json"
      [exports.analysis]
      auto = false
      path = "bacon-analysis.json"

  # Uncomment and change the key-bindings you want to define
  # (some of those ones are the defaults and are just here for illustration)
      [keybindings]

      [jobs.bacon-ls]
      command = [ "cargo", "clippy", "--workspace", "--tests", "--all-targets", "--all-features", "--message-format", "json-diagnostic-rendered-ansi" ]
      analyzer = "cargo_json"
      need_stdout = true

      [exports.cargo-json-spans]
      auto = true
      exporter = "analyzer"
      line_format = "{diagnostic.level}|:|{span.file_name}|:|{span.line_start}|:|{span.line_end}|:|{span.column_start}|:|{span.column_end}|:|{diagnostic.message}|:|{diagnostic.rendered}|:|{span.suggested_replacement}"
      path = ".bacon-locations"
    '';

  home.packages = [
    pkgs.fswatch
    pkgs.entr
    pkgs.rubik
    pkgs.emacs
    pkgs.python312Packages.pipx
  ];
}
