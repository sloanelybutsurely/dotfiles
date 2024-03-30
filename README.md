# dotfiles
⚙️ My personal and professional development environment setup and configuration

## Usage

### Install nix

I've used the [DeterminateSystems installer](https://github.com/DeterminateSystems/nix-installer?tab=readme-ov-file#the-determinate-nix-installer).

### Install Homebrew

_(This is mostly to use casks to install GUI applications.)_

Use the instructions on [brew.sh](https://brew.sh/).

### Run first time setup

If the current hostname and username of are already defined in the [nix-darwin config](./.config/nix-darwin) you can run `nix-darwin` to bootstrap the machine.

```sh
nix run nix-darwin -- switch --flake 'github:sloanelybutsurely/dotfiles?dir=.config/nix-darwin'
```

<details>
<summary>New hostname or username</summary>

If you're setting up a brand new machine or using a new username you'll have to clone this repo and update the `nix-darwin` config to include the new hostname and/or username.

If you commit and push these changes you can continue these instructions from the above.

If you want to bootstrap from a local copy of this repo you can run `nix-darwin`:

```sh
nix run nix-darwin -- switch --flake /path/to/.config/nix-darwin
```

</details>


### Set shell

```sh
chsh -s /run/current-system/sw/bin/fish
```

### Reboot the machine

This will let the new shell take hold.

### Clone remaining dotfiles and nix-darwin

Once setup you can fetch a local copy of the nix-darwin config and some remaining dotfiles.

```sh
# yadm should have been installed by 
yadm clone git@github.com:sloanelybutsurely/dotfiles.git
```
