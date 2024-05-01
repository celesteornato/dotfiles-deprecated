{ pkgs }:

pkgs.writeShellScriptBin "wallswap" ''
  cp $1 ../wallpapers/background
  ${pkgs.pywal}/bin/wal -i $1
  ${pkgs.swaybg}/bin/swaybg -i $1
''
