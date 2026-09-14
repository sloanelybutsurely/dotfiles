# sloanelybutsurely/nixvim-flake

neovim config via [nixvim]

## try it out

if you have [nix installed][nix-installer] you can try out my setup without
affecting your own.

```sh
nix run github:sloanelybutsurely/nixvim-flake
```

[nixvim]: https://github.com/nix-community/nixvim
[nix-installer]: https://github.com/DeterminateSystems/nix-installer

## usage

### keys

`;` and `q;` have been remapped to `:` and `q:` for convenience.

`<SPACE>` is the leader key.

`<ESC>` will stop highlighting the current search.

#### leader bindings

| key | action |
| - | - |
| `<leader>w` | `:w` (save / write) |
| `<leader>q` | `:q` (close / quit) |
| `<leader>p` | paste from `+` buffer (system clipboard) |
| `<leader>P` | paste from `+` buffer (system clipboard) |
| `<leader><space>` | fuzzy-find files |
| `<leader>/` | fuzzy-find _in_ files |
| `<leader>g` ... | git actions using fugitive |
