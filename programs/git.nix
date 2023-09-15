{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Rick Henry";
    userEmail = "rickhenry@rickhenry.dev";
    extraConfig = {
      core = {
        editor = "nvim";
        autocrlf = "input";
      };
      init = {
        defaultBranch = "main";
      };
      pull = {
        ff = "only";
      };
    };
    ignores = [
      ".DS_Store"
      "*~"
      "*.un~"
      "*.sw*"
      ".vimbackup"
      ".bak*"
      "dist"
      "build"
      "*.egg-info"
      "__pycache__"
      "*.pyc"
      "*.pyx"
      "venv*"
      ".cache"
      ".tox"
      ".eggs"
      ".env"
      ".coverage"
      "coverage.xml"
      "htmlcov"
      ".pytest_cache"
      "*.o"
      "terraform.tfvars"
      ".vscode"
      "node_modules/"
      "env.yml"
      "yarn-error.log"
      ".serverless"
      "*-autosave.kra"
      "justpy.env"
      "target/"
      "debug/"
      "build/"
      ".deta"
      ".dynamodb"
      ".idea"
      "_build"
      ".direnv"
      ".envrc"
      "*.db"
      "*.db-wal"
      "*.db-shm"
      "*.db-litestream"
      ".devenv*"
      "devenv.local.nix"
    ];
    lfs.enable = true;
  };

}
