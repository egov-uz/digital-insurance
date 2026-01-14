{
  inputs,
  system,
}: let
  pkgs = inputs.nixpkgs.legacyPackages.${system};
in rec {
  # Used by `nix build ...`
  packages = {
    di-front = pkgs.callPackage ./package.nix {inherit pkgs;};
  };
  # Used by `nix develop ...`
  devShells = {
    di-front = import ./shell.nix packages.di-front {inherit pkgs;};
  };
}
