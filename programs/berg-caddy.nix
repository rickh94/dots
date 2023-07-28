{ pkgs, config, plugins, ... }:
with pkgs;
stdenv.mkDerivation rec {
  pname = "caddy";
  version = "latest";

  nativeBuildInputs = [ git go xcaddy ];

  configurePhase = ''
    export GOCACHE=$TMPDIR/go-cache
    exoprt GOPATH=$TMPDIR/go
  '';

  buildPhase =
    let
      pluginArgs = lib.concatMapStringsSep " " (plugin: "--with ${plugin}") plugins;
    in
    ''
      runHook preBuild
      ${xcaddy}/bin/xcaddy build latest ${pluginArgs}
      runHook postBuild
    '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mv caddy $out/bin
    runHook postInstall
  '';

}
