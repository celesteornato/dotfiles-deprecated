{ pkgs }:

pkgs.writeShellScriptBin "wallswap" ''
  cp $1 ~/.dotfiles/wallpapers/background
  ${pkgs.pywal}/bin/wal -i $1
  ${pkgs.sway}/bin/swaymsg reload
''
