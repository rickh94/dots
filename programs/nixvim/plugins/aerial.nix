{ ...
}: {
  programs.nixvim.plugins.aerial = {
    enable = true;
  };

  programs.nixvim.keymaps = [
    {
      action = "<cmd>AerialToggle!<cr>";
      key = "<leader>A";
      mode = [ "n" ];
    }
  ];

}
