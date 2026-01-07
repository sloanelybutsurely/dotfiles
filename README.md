# dotfiles

these are my personal dotfiles (current as of jan 2026).

i currently use [gnu stow][stow] to create symlinks from wherever this repo is
cloned to.

i have used some other systems in the past. the repos containing those
configurations are available below:

- [nix, nix-darwin, and
  home-manager](https://git.sloane.sh/sloanelybutsurely/nix-dotfiles)
- [yadm](https://git.sloane.sh/sloanelybutsurely/yadm-dotfiles)

## setup

installing:

```sh
stow . -t $HOME --dotfiles
```

uninstalling:

```sh
stow . -t $HOME --dotfiles --delete
```

[stow]: https://www.gnu.org/software/stow/
