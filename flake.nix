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
      }: rec {
        # Nix script formatter
        formatter = pkgs.alejandra;

        # Repositories of monorepo
        projects = {
          di-book = import ./di-book {inherit inputs system;};
          di-core = import ./di-core {inherit inputs system;};
          di-stimerch = import ./di-stimerch {inherit inputs system;};
          di-conformance = import ./di-conformance {inherit inputs system;};
        };

        # Development environment
        devShells = {
          default = import ./shell.nix {inherit pkgs;};
        };

        # Output package
        packages = with projects;
          di-book // di-core // di-stimerch // di-conformance;

        # Unified devShells
        devShell =
          (import ./merge.nix {inherit pkgs;})
          (pkgs.lib.attrsets.attrValues devShells);
      };
    });
}
