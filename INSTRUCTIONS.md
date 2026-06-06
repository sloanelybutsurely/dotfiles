# Unifying the nix config

## Target structure

```
flake.nix
modules/
  nixos/
    base.nix        # boot, network, timezone, fish, sway, ly, interception-tools, fonts, user, packages
    sway.nix        # sway + ly + interception-tools (if you want to split it out)
    audio.nix       # pipewire
    power.nix       # thermald + tlp
  home/
    base.nix        # packages all machines share: ripgrep, fd, jujutsu, neovim, difftastic, zoxide
    linux.nix       # linux home: 1password, firefox, rofi, aerc, foot/sway config links
    darwin.nix      # mac home: fish functions, alacritty/newsboat config links
hosts/
  nixos-desktop/
    default.nix
    hardware-configuration.nix
  nixos-thinkpad/
    default.nix
    hardware-configuration.nix
  macbook-air/
    default.nix
```

## Steps

### 1. Create the root flake.nix

Combine the three per-machine `flake.nix` files into one at the repo root. The NixOS and macOS machines use different nixpkgs branches, so inputs needs two nixpkgs entries:

```nix
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
};
```

Pass `nixpkgs-darwin` when building the darwin system, `nixpkgs` for the NixOS systems. Home-manager follows `nixpkgs` (the NixOS one) — this is fine because `useGlobalPkgs = true` means home-manager uses the system's pkgs on each machine anyway, not its own evaluated nixpkgs. The outputs block should declare:
- `nixosConfigurations.nixos-desktop`, `nixosConfigurations.nixos-thinkpad`
- `darwinConfigurations.macbook-air`

Each host wires up its system config and home-manager config here. Delete the three per-machine `flake.nix` files when done. Run `nix flake update` from the root to generate a unified `flake.lock`.

### 2. Create modules/nixos/base.nix

Move everything both NixOS machines share into this file:
- systemd-boot + EFI
- networkmanager
- timezone
- fish, sway, ly, interception-tools
- fonts
- system packages (neovim, wget, git)
- users.users.sloane

Leave out: hostname, stateVersion, hardware imports, machine-specific services.

### 3. Optionally split nixos modules further

If you want sway, audio, or power management to be individually toggleable, put each in its own file (`modules/nixos/sway.nix`, etc.). If you're happy with "all NixOS machines get sway," keep it all in base.nix.

### 4. Create modules/home/base.nix

Packages all three machines share: ripgrep, fd, jujutsu, neovim, difftastic, zoxide. Keep it narrow — only things genuinely shared.

### 5. Create modules/home/linux.nix

Everything both NixOS machines' home configs share:
- home.username, homeDirectory, stateVersion
- packages: 1password, fish, qutebrowser, discord, difftastic, weechat, aerc
- xdg.configFile links: fish, jj, foot, nvim, sway
- programs.firefox, programs.ssh (1password agent), programs.rofi, programs.aerc

### 6. Create modules/home/darwin.nix

Mac-specific home config:
- home.username, homeDirectory, stateVersion
- packages: htop, wget, zellij, aerc, newsboat
- fish abbreviations and functions (rebuild-system, etc.)
- xdg.configFile links: alacritty, newsboat, nvim

### 7. Slim down each host

`hosts/nixos-desktop/default.nix`:
```nix
{ imports = [ ../../modules/nixos/base.nix ./hardware-configuration.nix ];
  networking.hostName = "nixos-desktop";
  services.udisks2.enable = true;
  system.stateVersion = "26.05"; }
```

`hosts/nixos-thinkpad/default.nix`:
```nix
{ imports = [ ../../modules/nixos/base.nix ./hardware-configuration.nix ];
  networking.hostName = "nixos-thinkpad";
  i18n.defaultLocale = "en_US.UTF-8";
  services.thermald.enable = true;
  services.tlp.enable = true;
  services.printing.enable = true;
  services.pipewire = { enable = true; pulse.enable = true; };
  system.stateVersion = "26.05"; }
```

`hosts/macbook-air/default.nix`: the existing macbook-air/configuration.nix, moved here.

### 8. Wire home modules in flake.nix

For each host, pass the right home modules to home-manager:

```nix
home-manager.users.sloane = { imports = [
  ./modules/home/base.nix
  ./modules/home/linux.nix   # nixos hosts
  # ./modules/home/darwin.nix  # macbook
]; };
```

Machine-specific home extras (e.g. desktop's udiskie service, weechat config link) can either go inline here or in a small `hosts/nixos-desktop/home.nix` that's added to the imports list.

### 9. Update rebuild commands

From the repo root:
- NixOS: `sudo nixos-rebuild switch --flake .#nixos-desktop`
- macOS: `darwin-rebuild switch --flake .#macbook-air`

Update the `rebuild-system` fish function on the macbook to point to the repo root.
