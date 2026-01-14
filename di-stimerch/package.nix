{
  pkgs ? let
    lock = (builtins.fromJSON (builtins.readFile ../flake.lock)).nodes.nixpkgs.locked;
    nixpkgs = fetchTarball {
      url = "https://github.com/nixos/nixpkgs/archive/${lock.rev}.tar.gz";
      sha256 = lock.narHash;
    };
  in
    import nixpkgs {overlays = [];},
  ...
}: let
  lib = pkgs.lib;
  manifest = (pkgs.lib.importTOML ./Cargo.toml).workspace.package;
in
  pkgs.rustPlatform.buildRustPackage {
    pname = manifest.name;
    version = manifest.version;
    src = pkgs.lib.cleanSource ./.;

    cargoLock = {
      lockFile = ./Cargo.lock;
    };

    nativeBuildInputs = with pkgs; [
      pkg-config
      postgresql
      openssl
    ];

    buildInputs = with pkgs; [
      postgresql
      openssl
    ];

    fixupPhase = ''
      mkdir -p $out/mgrs
      cp -R ./crates/database/* $out/mgrs
    '';

    meta = with lib; {
      homepage = manifest.homepage;
      description = manifest.description;
      license = with licenses; [cc0];
      platforms = with platforms; linux ++ darwin;
      mainProgram = "server";
      maintainers = with maintainers; [orzklv];
    };
  }
