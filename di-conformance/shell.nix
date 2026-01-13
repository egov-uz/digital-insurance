package: {pkgs, ...}:
pkgs.mkShell {
  inputsFrom = [package];

  packages = with pkgs; [
    nixd
    statix
    deadnix
    alejandra

    rustfmt
    clippy
    rust-analyzer
    cargo-watch

    # Other packages here
    # openssl
    # libressl
    # ...
  ];

  # RUST_BACKTRACE = "full";
  # RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";

  shellHook = ''
    # Extra steps to do while activating development shell
  '';
}
