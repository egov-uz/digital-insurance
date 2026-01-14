{
  # oooooooooooo   .oooooo.      .oooooo.   oooooo     oooo    oooooooooo.   ooooo
  # `888'     `8  d8P'  `Y8b    d8P'  `Y8b   `888.     .8'     `888'   `Y8b  `888'
  #  888         888           888      888   `888.   .8'       888      888  888
  #  888oooo8    888           888      888    `888. .8'        888      888  888
  #  888    "    888     ooooo 888      888     `888.8'         888      888  888
  #  888       o `88.    .88'  `88b    d88'      `888'          888     d88'  888
  # o888ooooood8  `Y8bood8P'    `Y8bood8P'        `8'          o888bood8P'   o888o
  description = "A monstrosity monorepo containing every part of Digital Insurance project";

  # Extra nix configurations to inject to flake scheme
  # => use if something doesn't work out of box or when despaired...
  nixConfig = {
    experimental-features = ["nix-command" "flakes" "pipe-operators"];
    extra-substituters = ["https://cache.xinux.uz/"];
    extra-trusted-public-keys = ["cache.xinux.uz:BXCrtqejFjWzWEB9YuGB7X2MV4ttBur1N8BkwQRdH+0="];
  };

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
          di-cnfm = import ./di-cnfm {inherit inputs system;};
          di-front = import ./di-front {inherit inputs system;};
          di-stimerch = import ./di-stimerch {inherit inputs system;};
        };
      in rec {
        # Nix script formatter
        formatter = pkgs.alejandra;

        # Output package
        packages = with projects;
          di-book.packages
          // di-core.packages
          // di-cnfm.packages
          // di-front.packages
          // di-stimerch.packages;

        # Development environment
        devShells = with projects;
          {
            default = merge devShells;
            global = import ./shell.nix {inherit pkgs;};
          }
          // di-book.devShells
          // di-core.devShells
          // di-cnfm.devShells
          // di-front.devShells
          // di-stimerch.devShells;
      };
    });
}
