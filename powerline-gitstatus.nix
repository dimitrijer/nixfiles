{ pkgs ? import <nixpkgs> {} }:

with pkgs.python3Packages;
buildPythonPackage rec {
  pname = "powerline-gitstatus";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0k5m85vi8p7dzq5c0p60h5dnjm96wllxxp3zvvsfvh88h2jvnlim";
  };

  # Needs powerline, yet we want to add this dependency to powerline.
  doCheck = false;

  meta = with pkgs.lib; {
    homepage = "https://github.com/jaspernbrouwer/powerline-gitstatus";
    description = "A Powerline segment for showing the status of a Git working copy.";
    license = licenses.mit;
  };
}
