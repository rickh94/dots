{ pkgs, ... }: {
  text =
    ''
      command = "${pkgs.fish}/bin/fish -l"
      window-padding-x = 20
      window-padding-y = 20
      window-theme = "ghostty"
      theme = "catppuccin-macchiato"
    '';
}
