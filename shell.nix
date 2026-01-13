{pkgs, ...}:
pkgs.mkShell {
  name = "digital-insurance-dev";

  packages = with pkgs; [
    nixd
    alejandra
    statix
    deadnix
  ];
}
