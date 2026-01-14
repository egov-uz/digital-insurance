package: {pkgs, ...}:
pkgs.mkShell {
  inputsFrom = [package];

  packages = with pkgs; [
    rustfmt
    clippy
    rust-analyzer
    cargo-watch

    diesel-cli
    diesel-cli-ext

    just
    just-lsp
  ];

  RUST_BACKTRACE = "full";
  RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";

  shellHook = ''
    # Starts postgres on nix-shell level
    # source ./scripts/init-db.sh
    # Starts the server on watch mode
    # source ./scripts/init-service.sh
  '';

  ####################################################################
  # Without  this, almost  everything  fails with  locale issues  when
  # using `nix-shell --pure` (at least on NixOS).
  # See
  # + https://github.com/NixOS/nix/issues/318#issuecomment-52986702
  # + http://lists.linuxfromscratch.org/pipermail/lfs-support/2004-June/023900.html
  ####################################################################

  LOCALE_ARCHIVE =
    if pkgs.stdenv.isLinux
    then "${pkgs.glibcLocales}/lib/locale/locale-archive"
    else "";
}
