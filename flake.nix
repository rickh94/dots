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
    {
      nixosConfigurations.beethoven = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/beethoven/configuration.nix
        ];
        specialArgs = { inherit nixpkgs; };
      };

      darwinConfigurations.stravinsky = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        modules = [
          ./hosts/stravinsky/darwin-configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.users.rick = import ./hosts/stravinsky/home.nix;
          }
        ];
      };

      homeConfigurations.beethoven = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [ ./hosts/beethoven/home.nix ];
      };

      defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;
      defaultPackage.aarch64-darwin = home-manager.defaultPackage.aarch64-darwin;
    };
}
