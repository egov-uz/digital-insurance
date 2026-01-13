flake: {pkgs, ...}: let
  # Hostplatform system
  system = pkgs.hostPlatform.system;

  # Production package
  base = flake.packages.${system}.default;
in
  pkgs.mkShell {
    inputsFrom = [base];

    packages = with pkgs; [
      nixd
      statix
      deadnix
      alejandra

      taplo
    ];

    shellHook = ''
      # Extra steps to do while activating development shell
    '';
  }
