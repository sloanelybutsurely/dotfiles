# flake-parts + import-tree approach

This is one step beyond INSTRUCTIONS.md. The payoff: feature modules are auto-imported
and a single file can contribute to NixOS, nix-darwin, and home-manager simultaneously.

## Three new concepts

**flake-parts** replaces the `outputs = { ... }: { ... }` function with a module system.
Each file contributes to flake outputs as a module instead of everything living in one function.

**import-tree** replaces manual import lists. `inputs.import-tree [ ./modules ]` auto-imports
every .nix file in that directory. Adding a feature = dropping a file. No registration step.

**`flake.modules`** is a custom option enabled by `inputs.flake-parts.flakeModules.modules`.
It stores NixOS/darwin/home-manager modules as *values* using the `deferredModule` type,
so you can compose them like data before passing them to `nixosSystem`/`darwinSystem`.
This is what lets a single file contribute to multiple system types.

## Structure

```
flake.nix
modules/
  flake-parts.nix     # enables flake.modules option
  base.nix            # assembles features into named composites
  users.nix           # flake.modules.nixos.users + flake.modules.darwin.users
  sway.nix            # flake.modules.nixos.sway + flake.modules.home.sway
  audio.nix           # flake.modules.nixos.audio
  power.nix           # flake.modules.nixos.power (thinkpad only)
  fonts.nix           # flake.modules.nixos.fonts + flake.modules.darwin.fonts
  hosts/
    nixos-desktop.nix
    nixos-thinkpad.nix
    macbook-air.nix
  hardware/
    nixos-desktop.nix  # moved from nixos-desktop/hardware-configuration.nix
    nixos-thinkpad.nix
```

## flake.nix

```nix
{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    imports = inputs.import-tree [ ./modules ];
  };
}
```

## modules/flake-parts.nix

Enables the `flake.modules` option used everywhere else:

```nix
{ inputs, ... }: {
  imports = [ inputs.flake-parts.flakeModules.modules ];
}
```

## A feature module (e.g. modules/sway.nix)

One file, one feature, both system and home config:

```nix
{ ... }: {
  flake.modules.nixos.sway = {
    programs.sway.enable = true;
    services.displayManager.ly.enable = true;
    services.interception-tools.enable = true;
  };

  flake.modules.home.sway = { config, ... }: let
    link = config.lib.file.mkOutOfStoreSymlink;
    cfg = "${config.home.homeDirectory}/.config/nixos/config";
  in {
    xdg.configFile."sway" = { source = link "${cfg}/sway"; recursive = true; };
    programs.rofi.enable = true;
  };
}
```

## modules/base.nix

Composes features into named sets that hosts import:

```nix
{ config, ... }: let m = config.flake.modules; in {
  flake.modules.nixos.base = { imports = [
    m.nixos.boot m.nixos.users m.nixos.fonts m.nixos.sway
  ]; };

  flake.modules.darwin.base = { imports = [
    m.darwin.fonts m.darwin.users
  ]; };

  flake.modules.home.linux-base = { imports = [
    m.home.packages m.home.sway m.home.ssh
  ]; };

  flake.modules.home.darwin-base = { imports = [
    m.home.packages m.home.darwin
  ]; };
}
```

## A host (e.g. modules/hosts/nixos-desktop.nix)

```nix
{ inputs, config, ... }: let m = config.flake.modules; in {
  flake.nixosConfigurations.nixos-desktop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      m.nixos.base
      ./hardware/nixos-desktop.nix
      inputs.home-manager.nixosModules.home-manager
      {
        networking.hostName = "nixos-desktop";
        services.udisks2.enable = true;
        system.stateVersion = "26.05";
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "backup";
        home-manager.users.sloane = { imports = [ m.home.linux-base ]; };
      }
    ];
  };
}
```

The thinkpad host is identical in shape but adds `m.nixos.audio` and `m.nixos.power` to its
imports and sets thinkpad-specific options. The macbook host uses `inputs.nix-darwin.lib.darwinSystem`
and `nixpkgs-darwin` instead.

## Tradeoffs vs. the simple approach

Gains:
- Adding a feature = one new file, auto-discovered, no registration
- Feature's system config and home config live together in one file
- Hosts are declarative lists of features, easy to diff and understand

Costs:
- Two new tools to understand (flake-parts, import-tree)
- `flake.modules` / `deferredModule` is a non-obvious abstraction
- Errors can be harder to trace since module evaluation is deferred

For three machines this is probably worth it if you expect the config to keep growing.
If it stays small, the simple approach in INSTRUCTIONS.md is easier to debug.
