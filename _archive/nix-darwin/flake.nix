{
  description = "Sloane's Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, darwin, nixpkgs, home-manager, nixvim }:
  let
    globalModules = [
      { system.configurationRevision = self.rev or self.dirtyRev or null; }
    ];
    globalDarwinModules = globalModules ++ [
      ./modules/darwin/global.nix
      nixvim.nixDarwinModules.nixvim
      home-manager.darwinModules.home-manager
      ./modules/darwin/nixvim.nix
    ];
  in {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Sloanes-MacBook-Air
    darwinConfigurations."Sloanes-MacBook-Air" = darwin.lib.darwinSystem {
      modules = globalDarwinModules ++ [ 
        ./hosts/Sloanes-MacBook-Air/default.nix
        {
          users.users.sloane.home = "/Users/sloane";
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.sloane = import ./users/sloane/default.nix;
          };
        }
      ];
    };

    darwinConfigurations."Sloanes-MacBook-Pro" = darwin.lib.darwinSystem {
      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      modules = globalDarwinModules ++ [ 
        ./hosts/Sloanes-MacBook-Pro/default.nix
        {
          users.users.sloane.home = "/Users/sloane";
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.sloane = import ./users/sloane/default.nix;
          };
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    # darwinPackages = self.darwinConfigurations."Sloanes-MacBook-Air".pkgs;
  };
}
