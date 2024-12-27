## My nixfiles

I have been playing around with Nix for a while. This is me trying to rewrite my
dotfiles with Nix in mind.

### Cold start

```bash
nix-channel --add https://github.com/dimitrijer/nixfiles/archive/main.tar.gz nixfiles
nix-channel --update
nix-env -iA nixfiles.neovim nixfiles.python3 nixfiles.tmux
```
