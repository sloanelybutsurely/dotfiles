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

installing configuration for a given program:

```sh stow <program> -t $HOME --dotfiles ```

[stow]: https://www.gnu.org/software/stow/
