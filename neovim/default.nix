{ pkgs }:

let
  vimRC = ""
  "";
in pkgs.neovim.override {
  configure = {
    customRC = vimRC;

    packages.myPlugins = with pkgs.vimPlugins; {
      start = [
      ];
    };
  };
}
