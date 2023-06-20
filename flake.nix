{
  description = "NixOs and home-manager configuration for mac";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-23.05";
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

    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    codeium = {
      url = "github:jcdickinson/codeium.nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs@{ self, nixpkgs, darwin, home-manager, unstable, codeium }:
    let
      chosenfonts = [ "FiraCode" "Hack" "CascadiaCode" "Hasklig" "Lilex" "VictorMono" "Hermit" ];
    in
    {
      nixpkgs.config.allowUnfree = true;

      # NIXOS HOST
      nixosConfigurations = {
        beethoven = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/beethoven/configuration.nix
          ];
          specialArgs = { inherit nixpkgs; inherit inputs; inherit chosenfonts; };
        };

        nixvm = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/nixvm/configuration.nix
          ];
          specialArgs = { inherit nixpkgs; inherit chosenfonts; };
        };

        nixserver = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/nixserver/configuration.nix
          ];
          specialArgs = { inherit nixpkgs; };
        };
      };

      # DARWIN HOSTS
      darwinConfigurations = {
        # main macbook pro
        stravinsky = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          modules = [
            ./hosts/stravinsky/darwin-configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.users.rick = import ./hosts/stravinsky/home.nix;
            }
          ];
          specialArgs = { inherit chosenfonts; };
        };

        fakestravinsky = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          modules = [
            ./hosts/stravinsky/darwin-configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.users.rick = import ./hosts/strvinsky/home.nix;
            }
          ];
        };

        aarch64minimalvm = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          modules = [
            ./hosts/macvm/darwin-configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.users.rick = import ./hosts/macvm/home.nix;
            }
          ];
        };

        x86minimalvm = darwin.lib.darwinSystem {
          system = "x86_64-darwin";
          pkgs = nixpkgs.legacyPackages.x86_64-darwin;
          modules = [
            ./hosts/macvm/darwin-configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.users.rick = import ./hosts/macvm/home.nix;
            }
          ];
        };
      };

      homeConfigurations = {
        beethoven = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
              system = "x86_64-linux";
              overlays = [codeium.overlays.x86_64-linux.default];
            };
          modules = [
            ./hosts/beethoven/home.nix
          ];
          extraSpecialArgs = { inherit inputs; inherit chosenfonts; i3mod = "Mod4"; };
        };

        chopin = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
              system = "x86_64-linux";
              overlays = [codeium.overlays.x86_64-linux.default];
            };
          modules = [
            ./hosts/chopin/home.nix
          ];
          extraSpecialArgs = { inherit inputs; inherit chosenfonts; };
        };

        nixvm = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
              system = "x86_64-linux";
              overlays = [codeium.overlays.x86_64-linux.default];
            };
          modules = [ ./hosts/nixvm/home.nix ];
          extraSpecialArgs = { inherit inputs; inherit chosenfonts; i3mod = "Control"; };
        };

        nixserver = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [ ./hosts/nixserver/home.nix ];
        };

        proxyserver = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [ ./hosts/proxy-server/home.nix ];
        };
      };

      #      defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;
      defaultPackage.aarch64-darwin = home-manager.defaultPackage.aarch64-darwin;
    };
}
