{
  inputs,
  system,
}: let
  # Packages
  pkgs = inputs.nixpkgs.legacyPackages.${system};
in rec {
  # Used by `nix build ...`
  packages = {
    di-book = pkgs.callPackage ./package.nix {inherit pkgs;};
  };
  # Used by `nix develop ...`
  devShells = {
    di-book = import ./shell.nix packages.di-book {inherit pkgs;};
  };
}
