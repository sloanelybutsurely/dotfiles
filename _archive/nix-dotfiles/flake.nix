{
  description = "sloanelybutsurely's dotfiles via nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows ="nixpkgs";
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, nixvim }:
  {
    darwinConfigurations."Sloanes-MacBook-Air" = nix-darwin.lib.darwinSystem {
      modules = [
        {
          system.configurationRevision = self.rev or self.dirtyRev or null;
        }
        ./nix-darwin
        ./nix-darwin/hosts/Sloanes-MacBook-Air
        home-manager.darwinModules.home-manager
        {
          users.users.sloane.home = "/Users/sloane";
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "before-home-manager";
            extraSpecialArgs = {
              inherit nixvim;
            };
            users.sloane = import ./home-manager/users/sloane.nix;
          };
        }
      ];
    };
  };
}
