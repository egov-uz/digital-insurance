{
  inputs,
  system,
}: let
  pkgs = inputs.nixpkgs.legacyPackages.${system};
in rec {
  # Used by `nix build ...`
  packages = {
    di-cnfm = pkgs.callPackage ./package.nix {inherit pkgs;};
  };
  # Used by `nix develop ...`
  devShells = {
    di-cnfm = import ./shell.nix packages.di-cnfm {inherit pkgs;};
  };
}
