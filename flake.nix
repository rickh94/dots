{
  description = "NixOs and home-manager configuration for mac";

  inputs = {
      nixpkgs = {
        url = "github:nixos/nixpkgs/nixos-22.11";
      };
      /* nixos-hardware.url = "github:nixos/nixos-hardware/master"; */
      home-manager = {
          url = "github:nix-community/home-manager";
          inputs.nixpkgs.follows = "nixpkgs";
        };

      darwin = {
          url = "github:lnl7/nix-darwin/master";
          inputs.nixpkgs.follows = "nixpkgs";
        };

    };

  outputs = { self, nixpkgs, darwin, home-manager }: 
  let 
    homeManagerConfFor = config:
    { ... }: {
      inports = [ config ];
      };

    darwinSystem = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./hosts/stravinsky/darwin-configuration.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.users.rick = homeManagerConfFor ./hosts/stravinsky/home.nix;
        }
      ];
      specialArgs = { inherit nixpkgs; };
    };
  in
  {
    nixosConfigurations.beethoven = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/beethoven/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useUserPackages = true;
          home-manager.users.rick = homeManagerConfFor ./hosts/beethoven/home.nix;
        }
      ];
      specialArgs = { inherit nixpkgs; };
    };
    homeConfigurations.beethoven = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [ ./hosts/beethoven/home.nix ];
    };

    homeConfigurations.stravinsky = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
    };
    
    defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;
    defaultPackage.aarch64-darwin = home-manager.defaultPackage.aarch64-darwin;
  };
}
