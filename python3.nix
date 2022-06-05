{ pkgs ? import <nixpkgs> {} }:

let 
  powerline-gitstatus = import ./powerline-gitstatus.nix { pkgs = pkgs; };
in 
  pkgs.python3.withPackages (ps: [ ps.powerline powerline-gitstatus ])
