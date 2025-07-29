{
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  imports = [
    ../../programs/zellij.nix
    ../../programs/helix.nix
    #../../programs/neovim
    ../../programs/git.nix
    ../../programs/starship.nix
    ../../programs/tmux.nix
    ../../programs/bat.nix
    ../../programs/fish.nix
  ];

  home = {
    stateVersion = "22.11";

    sessionPath = [
      "${config.home.homeDirectory}/go/bin"
      "${config.home.homeDirectory}/.cargo/bin"
      "${config.home.homeDirectory}/.local/bin"
      "${config.home.homeDirectory}/.config/composer/vendor/bin"
      "${config.home.homeDirectory}/.gem/ruby/3.3.0/bin"
      "${config.home.homeDirectory}/.zide/bin"
    ];
    sessionVariables = {
      EDITOR = "hx";
      NIXPKGS_ALLOW_UNFREE = 1;
      GEM_HOME = "${config.home.homeDirectory}/.gems";
      GEM_PATH = "${config.home.homeDirectory}/.gems";
    };

    packages = with pkgs; [
      # basics
      wget
      zoxide
      fish
      mosh
      zip
      unzip
      htop
      zstd
      pass
      zsh
      pv
      netcat
      git-crypt
      gnupg
      #
      # # languages
      go
      nodejs
      rustup
      ruby
      elixir
      erlang
      unstablePkgs.poetry
      unstablePkgs.bun
      #
      # rust replacements
      difftastic
      tealdeer
      dogdns
      starship
      fzf
      ripgrep-all
      ripgrep
      bottom
      eza
      fd
      du-dust
      bat
      xh
      fselect
      lua
      lazygit
      lldb
    ];
  };

  programs.bash.enable = true;
  programs.zsh.enable = true;

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.uv.enable = true;
  programs.yazi.enable = true;
}
