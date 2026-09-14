{
  description = "shared nixos, nix-darwin, and home-manager configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      nixpkgs-darwin,
      home-manager,
      ...
    }:
    {
      darwinConfigurations."macbook-air" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit self inputs; };
        modules = [
          ./modules/darwin/base.nix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "before-home-manager";
              users.sloane = {
                imports = [
                  ./modules/home/base.nix
                  ./modules/home/darwin.nix
                ];
              };
            };
          }
        ];
      };

      darwinConfigurations."Sloanes-Work-MacBook" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit self inputs; };
        modules = [
          ./modules/darwin/base.nix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "before-home-manager";
              users.sloane = {
                imports = [
                  ./modules/home/base.nix
                  ./modules/home/darwin.nix
                  ./modules/home/work.nix
                ];
              };
            };
          }
        ];
      };

      nixosConfigurations."nixos-thinkpad" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./modules/nixos/base.nix
          {
            imports = [
              ./modules/nixos/hosts/nixos-thinkpad/hardware-configuration.nix
              ./modules/nixos/hosts/nixos-thinkpad/network.nix
            ];
          }
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "before-home-manager";
              users.sloane = {
                imports = [
                  ./modules/home/base.nix
                  ./modules/home/nixos.nix
                  ./modules/home/hosts/nixos-thinkpad.nix
                ];
              };
            };
          }
        ];
      };

      nixosConfigurations."nixos-desktop" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./modules/nixos/base.nix
          {
            imports = [
              ./modules/nixos/hosts/nixos-desktop/hardware-configuration.nix
              ./modules/nixos/hosts/nixos-desktop/network.nix
            ];
          }
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "before-home-manager";
              users.sloane = {
                imports = [
                  ./modules/home/base.nix
                  ./modules/home/nixos.nix
                  ./modules/home/hosts/nixos-desktop.nix
                ];
              };
            };
          }
        ];
      };
    };
}
