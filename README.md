## Goals:

- [x] shared home-manager settings
- [x] NixOS configurations
  - [x] nixos-desktop
  - [x] nixos-thinkpad
- [x] nix-darwin configuration(s)
  - [x] macbook-air
- [x] Configuration across machines de-duplicated 
- [ ] Feature based blocks for configuration (shared across nixos & nix-darwin
  machines)

## Approach:

1. Start with separate configurations in subdirectories
2. Move separate configurations into single, top-level flake using explicit
   module `import`s
3. (?) Move to flake-parts / import-tree approach where features / settings are
   defined in feature modules and automatically imported

## Setup:

- Clone repo
- Create symlink from `~/.config/nix-config` to wherever you cloned the repo
- Install fonts (`./fonts`, requires ccrypt and password)
- Run first activation:
  - nix-darwin: `sudo nix run nix-darwin/nix-darwin-26.05#darwin-rebuild -- switch --flake ~/.config/nix-config#<hostname>`
  - nixos: `sudo nixos-rebuild switch --flake ~/.config/nix-config#<hostname>`
- Make changes and update: `rebuild-system`
