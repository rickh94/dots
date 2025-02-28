{
  description = "NixOs and home-manager configuration for mac";

  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
    allowUnfree = true;
    substituters = [
      "https://cache.nixos.org"
    ];
  };

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-24.11";
    };
    /*
      nixos-hardware.url = "github:nixos/nixos-hardware/master";
    */
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devenv.url = "github:cachix/devenv/latest";

    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    codeium = {
      url = "github:jcdickinson/codeium.nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nix-gaming.url = "github:fufexan/nix-gaming";
  };

  outputs =
    inputs @ { self
    , nixpkgs
    , darwin
    , home-manager
    , unstable
    , codeium
    , devenv
    ,
    }:
    let
      chosenfonts = [ "FiraCode" "Hack" "CascadiaCode" "Hasklig" "Lilex" "VictorMono" "Hermit" ];
    in
    {
      nixpkgs.config.allowUnfree = true;

      # NIXOS HOST
      nixosConfigurations = {
        wright = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/wright/configuration.nix
          ];
          specialArgs = {
            inherit nixpkgs;
            inherit inputs;
            inherit chosenfonts;
            unstablePkgs = unstable.legacyPackages.x86_64-linux;
          };
        };

        nixx86-vm = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/nixx86-vm/configuration.nix
          ];
          specialArgs = {
            inherit nixpkgs;
            inherit chosenfonts;

            unstablePkgs = unstable.legacyPackages.x86_64-linux;
          };
        };

        nixserver = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/nixserver/configuration.nix
          ];
          specialArgs = {
            inherit nixpkgs;
            inherit chosenfonts;
            inherit inputs;
            unstablePkgs = unstable.legacyPackages.x86_64-linux;
          };
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
              home-manager = {
                users.rick = import ./hosts/stravinsky/home.nix;
                extraSpecialArgs = {
                  inherit devenv;
                  unstablePkgs = unstable.legacyPackages.aarch64-darwin;
                };
              };
            }
          ];
          specialArgs = {
            inherit chosenfonts;
            inherit devenv;
            inherit unstable;
          };
        };
      };

      homeConfigurations = {
        wright = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            overlays = [ codeium.overlays.x86_64-linux.default ];
          };
          modules = [
            ./hosts/wright/home.nix
          ];
          extraSpecialArgs = {
            inherit inputs;
            inherit chosenfonts;
            inherit devenv;
            i3mod = "Mod4";
            unstablePkgs = unstable.legacyPackages.x86_64-linux;
          };
        };

        nixx86-vm = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
          };
          modules = [ ./hosts/nixx86-vm/home.nix ];
          extraSpecialArgs = {
            inherit inputs;
            inherit chosenfonts;
            inherit devenv;
            i3mod = "Control";
            unstablePkgs = unstable.legacyPackages.x86_64-linux;
          };
        };

        flyingdutchman = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
          };
          modules = [ ./hosts/flyingdutchman/home.nix ];
          extraSpecialArgs = {
            inherit inputs;
            inherit chosenfonts;
            inherit devenv;
            i3mod = "Control";
            unstablePkgs = unstable.legacyPackages.x86_64-linux;
          };
        };

        nixserver = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [ ./hosts/nixserver/home.nix ];
          extraSpecialArgs = {
            inherit inputs;
            inherit chosenfonts;
            inherit devenv;
            i3mod = "Control";
            codeium-lsp = inputs.codeium.packages.x86_64-linux.codeium-lsp;
            unstablePkgs = unstable.legacyPackages.x86_64-linux;
          };
        };
      };
    };
}
