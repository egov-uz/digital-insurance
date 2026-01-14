{pkgs, ...}:
pkgs.mkShell {
  packages = with pkgs; [
    nixd
    statix
    deadnix
    alejandra
  ];
}
