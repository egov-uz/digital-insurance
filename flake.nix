{
  description = "A beginning of an awesome project bootstrapped with github:bleur-org/templates";

  inputs = {
    # Stable for keeping thins clean
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    # Fresh and new for testing
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # The flake-parts library
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = {flake-parts, ...} @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} ({...}: {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      perSystem = {
        pkgs,
        system,
        ...
      }: let
        merge = import ./merge.nix {inherit pkgs;};

        # Repositories of monorepo
        projects = {
          di-book = import ./di-book {inherit inputs system;};
          di-core = import ./di-core {inherit inputs system;};
          di-stimerch = import ./di-stimerch {inherit inputs system;};
          di-conformance = import ./di-conformance {inherit inputs system;};
        };
      in rec {
        # Nix script formatter
        formatter = pkgs.alejandra;

        # Output package
        packages = with projects;
          di-book.packages
          // di-core.packages
          // di-stimerch.packages
          // di-conformance.packages;

        # Development environment
        devShells = with projects;
          {default = merge devShells;}
          // di-book.devShells
          // di-core.devShells
          // di-stimerch.devShells
          // di-conformance.devShells;
      };
    });
}
