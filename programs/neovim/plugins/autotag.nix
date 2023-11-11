{pkgs, ... }:
{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      nvim-ts-autotag
    ];

    extraLuaConfig = /* lua */ ''
      require('nvim-ts-autotag').setup({
        enable_close_on_slash = false,
        enable_close = false,
        filetypes = {
          'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue', 'tsx', 'jsx',
          'rescript', 'xml', 'php', 'markdown', 'astro', 'glimmer', 'handlebars', 'hbs', 'twig', 'htmldjango'
        },
      })
    '';

  };
}
