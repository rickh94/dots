{
  description = "NixOs and home-manager configuration for mac";

  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
    allowUnfree = true;
    trusted-users = [ "rick" ];
    substituters = [
      "https://cache.nixos.org"
    ];
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://pre-commit-hooks.cachix.org"
      "https://devenv.cachix.org"
      "https://nix-gaming.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
    ];
  };

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-25.05";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devenv.url = "github:cachix/devenv/latest";

    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    bacon_ls.url = "github:crisidev/bacon-ls";
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.05";

      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-gaming.url = "github:fufexan/nix-gaming";
    impermanence.url = "github:nix-community/impermanence";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
  };

  outputs =
    inputs @ { self
    , nixpkgs
    , darwin
    , home-manager
    , unstable
    , devenv
    , nixvim
    , bacon_ls
    , impermanence
    , nix-gaming
    , nix-flatpak
    ,
    }:
    let
      chosenfonts = [ "FiraCode" "Hack" "CascadiaCode" "Hasklig" "Lilex" "VictorMono" "Hermit" ];
    in
    {
      # NIXOS HOST
      nixosConfigurations = {
        gamer = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
          modules = [
            ./hosts/gamer/configuration.nix
            nix-gaming.nixosModules.pipewireLowLatency
            nix-gaming.nixosModules.platformOptimizations
            nix-gaming.nixosModules.ntsync
            impermanence.nixosModules.impermanence
            nix-flatpak.nixosModules.nix-flatpak
          ];
          specialArgs = {
            inherit inputs;
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

        nix-minimal-x86 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/nix-minimal/configuration.nix
            nixvim.nixosModules.nixvim
          ];
          specialArgs = {
            inherit nixpkgs;
            inherit chosenfonts;
            inherit nixvim;

            unstablePkgs = unstable.legacyPackages.x86_64-linux;
          };
        };

        nixserver = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
            config.packageOverrides = pkgs: {
              vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
            };
          };
          modules = [
            ./hosts/nixserver/configuration.nix
          ];
          specialArgs = {
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
                  inherit nixvim;
                  inherit bacon_ls;
                  unstablePkgs = unstable.legacyPackages.aarch64-darwin;
                };
              };
            }
          ];
          specialArgs = {
            inherit devenv;
            inherit unstable;
          };
        };
      };

      homeConfigurations = {
        gamer = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
            overlays = [ ];
          };
          modules = [
            ./hosts/gamer/home.nix
            nixvim.homeManagerModules.nixvim
          ];
          extraSpecialArgs = {
            inherit inputs;
            inherit devenv;
            inherit nixvim;
            inherit bacon_ls;
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
            unstablePkgs = unstable.legacyPackages.x86_64-linux;
          };
        };

        nix-minimal-x86 = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
          };
          modules = [
            ./hosts/nix-minimal/home.nix
            nixvim.homeManagerModules.nixvim
          ];
          extraSpecialArgs = {
            inherit inputs;
            inherit chosenfonts;
            inherit devenv;
            inherit nixvim;
            inherit bacon_ls;
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
            inherit nixvim;
            inherit bacon_ls;
            i3mod = "Control";
            unstablePkgs = unstable.legacyPackages.x86_64-linux;
          };
        };
      };
    };
}
