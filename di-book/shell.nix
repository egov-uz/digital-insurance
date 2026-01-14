package: {pkgs, ...}:
pkgs.mkShell {
  inputsFrom = [package];

  packages = with pkgs; [
    taplo
  ];

  shellHook = ''
    # Extra steps to do while activating development shell
  '';
}
