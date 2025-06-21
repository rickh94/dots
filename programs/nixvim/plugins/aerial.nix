{ ...
}: {
  plugins.aerial = {
    enabled = true;
  };

  keymaps = [
    {
      action = "<cmd>AerialToggle!<cr>";
      key = "<leader>A";
      mode = [ "n" ];
    }
  ];

}
