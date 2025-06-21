{ pkgs, ... }: {
  text =
    ''
      command = "${pkgs.fish}/bin/fish -l"
      window-padding-x = 5
      window-padding-y = 5
      window-theme = "ghostty"
      theme = "catppuccin-macchiato"
    '';
}
