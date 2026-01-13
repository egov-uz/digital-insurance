{
  inputs,
  system,
}: let
  pkgs = inputs.nixpkgs.legacyPackages.${system};
in rec {
  # Used by `nix build ...`
  packages = {
    di-conformance = pkgs.callPackage ./package.nix {inherit pkgs;};
  };
  # Used by `nix develop ...`
  devShells = {
    di-conformance = import ./shell.nix packages.di-conformance {inherit pkgs;};
  };
}
