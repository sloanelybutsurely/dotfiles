# sloanelybutsurely/nix-darwin

machine configuration via nix, nix-darwin, and home-manager

## installation

### install nix

i've used the [Determinate Nix Installer](https://github.com/DeterminateSystems/nix-installer)

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### clone this repo

```sh
mkdir -p ~/.config
git clone git@github.com:sloanelybutsurely/nix-darwin.git ~/.config/nix-darwin
```

### build and activate flake

since `darwin-rebuild` isn't available yet, use `nix run ...`

```sh
nix run nix-darwin -- switch --flake ~/.config/nix-darwin
```

this might take a while the first time. once it is done **restart the shell.**

### clone remaining dotfiles

_`yadm` should be available after switching for the first time._

```sh
yadm clone git@github.com:sloanelybutsurely/dotfiles.git
```

**note:** you might need to use `chsh -s` to set the nix managed fish shell as your default shell.

## making changes

if you make changes to `~/.config/nix-darwin` make sure all files are tracked by git and run `darwin-rebuild`

```sh
darwin-rebuild switch --flake ~/.config/nix-darwin
```
