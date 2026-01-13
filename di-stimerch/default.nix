{
  inputs,
  system,
}: let
  pkgs = inputs.nixpkgs.legacyPackages.${system};
in rec {
  # Used by `nix build ...`
  packages = {
    di-stimerch = pkgs.callPackage ./package.nix {inherit pkgs;};
  };
  # Used by `nix develop ...`
  devShells = {
    di-stimerch = import ./shell.nix packages.di-stimerch {inherit pkgs;};
  };
}
