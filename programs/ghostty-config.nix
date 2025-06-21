{ pkgs, ... }: {
  text =
    ''
      command = "${pkgs.fish}/bin/fish -l"
      window-padding-x = 2
      window-padding-y = 2
      window-theme = "ghostty"
      theme = "catppuccin-macchiato"
    '';
}
