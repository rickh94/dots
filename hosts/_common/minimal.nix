{ config
, pkgs
, nixpkgs
, lib
, inputs
, unstablePkgs
, ...
}: {
  imports = [
    ../../programs/neovim
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
    ];
    sessionVariables = {
      EDITOR = "nvim";
      MAKEFLAGS = "-j4";
      NIXPKGS_ALLOW_UNFREE = 1;
    };

    shellAliases = { };

    packages = with pkgs; [
      # basics
      wget
      tree
      # neovim
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

      # languages
      go
      nodejs
      rustup
      (python311.withPackages (ps: with ps; [ pip flake8 black ]))
      poetry
      unstablePkgs.bun

      # rust replacements
      difftastic
      tealdeer
      dogdns
      lfs
      starship
      carapace
      fzf
      ripgrep-all
      ripgrep
      bottom
      eza
      fd
      du-dust
      bat
      duf
    ];
  };

  programs.bash.enable = true;
  programs.zsh.enable = true;

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
}
