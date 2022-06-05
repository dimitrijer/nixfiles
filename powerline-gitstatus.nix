{ pkgs ? import <nixpkgs> {} }:

pkgs.python3Packages.buildPythonPackage rec {
  pname = "powerline-gitstatus";
  version = "1.3.1";
  buildInputs = [ pkgs.powerline ];
  src = pkgs.python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "0k5m85vi8p7dzq5c0p60h5dnjm96wllxxp3zvvsfvh88h2jvnlim";
  };
}
