{ pkgs
, inputs
, system
, lib
, ...
}: {
  imports = [
    ./full-base.nix
    # ./plugins/codeium-nix.nix
  ];
}
