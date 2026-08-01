{ pkgs ? import <nixpkgs> { } }:

let
  overlay = final: prev: {
    python3 = prev.python3.override {
      packageOverrides = pyFinal: pyPrev: {
        powerline = pyPrev.powerline.overridePythonAttrs (old: {
          version = "2.8.4-unstable-2026-03-11";
          src = final.fetchFromGitHub {
            owner = "powerline";
            repo = "powerline";
            # Fix for python 3.14
            rev = "11808cbe5c16e4621edcaefa916b5add81eab799";
            hash = "sha256-L7Xe2FQNXOmMZ94oyqTtpmT50brftP59g2c4l9oyBeI=";
          };
        });
      };
    };

    # python3Packages is not derived from the python3 attribute, so it has to be
    # pointed at the overridden interpreter explicitly. Without this,
    # powerline-gitstatus below would build against the stock package set.
    python3Packages = final.python3.pkgs;
  };

  patchedPkgs = pkgs.extend overlay;

  powerline-gitstatus = import ./powerline-gitstatus.nix { pkgs = patchedPkgs; };
in
patchedPkgs.python3.withPackages (ps: [ ps.powerline powerline-gitstatus ])
