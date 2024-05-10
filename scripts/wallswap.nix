{ pkgs }:

pkgs.writeShellScriptBin "wallswap" ''
  cp $1 ~/.dotfiles/wallpapers/background
  ${pkgs.pywal}/bin/wal -i $1
  ${pkgs.sway}/bin/swaymsg reload
  touch ~/.dotfiles/color-theme
  echo "" > ~/.dotfiles/color-theme
  for color_num in $(seq 2 8)
  do
    echo $(echo $(cat ~/.cache/wal/colors) | awk '{print $color_num}') >> ~/.dotfiles/color-theme 
  done
''
