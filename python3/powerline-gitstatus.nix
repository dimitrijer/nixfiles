{ pkgs ? import <nixpkgs> { } }:

with pkgs.python3Packages;
buildPythonPackage rec {
  pname = "powerline-gitstatus";
  version = "1.3.3";

  src = pkgs.fetchFromGitHub {
    owner = "jaspernbrouwer";
    repo = "powerline-gitstatus";
    rev = "v1.3.3";
    hash = "sha256-YhaGrxmNCnABfCa17rLVBVpQOhI54dKBEbDWohqmebE=";
  };

  pyproject = true;
  build-system = [ setuptools ];

  # Needs powerline, yet we want to add this dependency to powerline.
  doCheck = false;

  meta = with pkgs.lib; {
    homepage = "https://github.com/jaspernbrouwer/powerline-gitstatus";
    description = "A Powerline segment for showing the status of a Git working copy.";
    license = licenses.mit;
  };
}
