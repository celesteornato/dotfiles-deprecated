{ pkgs }:

pkgs.writeShellScriptBin "update" ''
  sudo nix flake update ~/.dotfiles/
  sudo nixos-rebuild switch --flake ~/.dotfiles/ --upgrade
''
