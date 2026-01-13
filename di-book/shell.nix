package: {pkgs, ...}:
pkgs.mkShell {
  inputsFrom = [package];

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
