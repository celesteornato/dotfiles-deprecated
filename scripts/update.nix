{ pkgs }:

pkgs.writeShellScriptBin "rebuild" ''
  sudo nix flake update ~/.dotfiles/
  sudo nixos-rebuild switch --flake ~/.dotfiles/ --upgrade
''
