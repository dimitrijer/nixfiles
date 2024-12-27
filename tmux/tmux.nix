{ pkgs ? import <nixpkgs> { } }:

let
  tmux = pkgs.tmux;
  tmux-conf = pkgs.writeText "tmux.conf" (import ./tmux-conf.nix { });
in pkgs.writeShellScriptBin "tmux" ''
  ${pkgs.tmux}/bin/tmux -f ${tmux-conf}
''
