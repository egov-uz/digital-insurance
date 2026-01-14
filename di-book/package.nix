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
  manifest = (pkgs.lib.importTOML ./book.toml).book;
in
  pkgs.stdenv.mkDerivation {
    pname = manifest.title;
    version = "0.0.1";
    src = pkgs.lib.cleanSource ./.;

    nativeBuildInputs = with pkgs; [
      mdbook
    ];

    buildPhase = ''
      mdbook build
    '';

    installPhase = ''
      mkdir -p $out
      mv ./book/{.,}* $out/
    '';

    meta = with lib; {
      homepage = manifest.website;
      description = "${manifest.title} documentation website generated with mdBook";
      license = with licenses; [cc0];
      platforms = with platforms; linux ++ darwin;
      maintainers = with maintainers; [orzklv];
    };
  }
