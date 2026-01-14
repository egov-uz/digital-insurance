package: {pkgs, ...}:
pkgs.mkShell {
  inputsFrom = [package];

  packages = with pkgs; [
    taplo
  ];
}
