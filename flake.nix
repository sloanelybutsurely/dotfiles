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

  outputs = inputs@{ self, nix-darwin, nixpkgs, nixpkgs-darwin, home-manager, ... }: {
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
            users.sloane = { imports = [
              ./modules/home/base.nix
              ./modules/home/darwin.nix
            ]; };
          };
        }
      ];
    };

		nixosConfigurations.nixos-thinkpad = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			modules = [
        ./modules/nixos/base.nix
        { imports = [ ./modules/nixos/hosts/nixos-thinkpad/hardware-configuration.nix ]; }
				home-manager.nixosModules.home-manager
				{
					home-manager = {
						useGlobalPkgs = true;
						useUserPackages = true;
						backupFileExtension = "before-home-manager";
						users.sloane = { imports = [
              ./modules/home/base.nix
              ./modules/home/nixos.nix
            ]; };
					};
				}
			];
		};
  };
}
