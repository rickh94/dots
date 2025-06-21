{ ...
}: {
  programs.nixvim.plugins.cmp = {
    enabled = true;
  };

  programs.nixvim.keymaps = [
    {
      action = "<cmd>AerialToggle!<cr>";
      key = "<leader>A";
      mode = [ "n" ];
    }
  ];

}
