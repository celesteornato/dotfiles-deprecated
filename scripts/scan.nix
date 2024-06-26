{ pkgs }:

pkgs.writeShellScriptBin "scan" ''
 scanimage -p -o $1 --format jpeg -d 'escl:https://172.16.0.21:443' --resolution 600
''
