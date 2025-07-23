{
  description = "NixOs and home-manager configuration for mac";

  nixConfig = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    allowUnfree = true;
    trusted-users = [ "rick" ];
    download-buffer-size = 2147483648;
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

    #bacon_ls.url = "github:crisidev/bacon-ls";
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.05";

      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-gaming.url = "github:fufexan/nix-gaming";
    impermanence.url = "github:nix-community/impermanence";
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    flatpaks.url = "github:in-a-dil-emma/declarative-flatpak/stable-v3";
    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      darwin,
      home-manager,
      unstable,
      devenv,
      nixvim,
      impermanence,
      nix-gaming,
      flatpaks,
      plasma-manager,
      nixpkgs-xr,
    }:
    let
      chosenfonts = [
        "FiraCode"
        "Hack"
        "CascadiaCode"
        "Hasklig"
        "Lilex"
        "VictorMono"
        "Hermit"
      ];
    in
    {
      # NIXOS HOST
      nixosConfigurations = {
        gamer = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
            config.cudaSupport = true;
            overlays = [
              nixpkgs-xr.overlays.default
            ];
          };
          modules = [
            ./hosts/gamer/configuration.nix
            nix-gaming.nixosModules.pipewireLowLatency
            nix-gaming.nixosModules.platformOptimizations
            nix-gaming.nixosModules.ntsync
            impermanence.nixosModules.impermanence
            flatpaks.nixosModule
            nixpkgs-xr.nixosModules.nixpkgs-xr
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
            impermanence.nixosModules.impermanence
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
                backupFileExtension = "bak";
                users.rick = import ./hosts/stravinsky/home.nix;
                extraSpecialArgs = {
                  inherit devenv;
                  inherit nixvim;
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
            config.cudaSupport = true;
            overlays = [
              nixpkgs-xr.overlays.default
            ];
          };
          modules = [
            ./hosts/gamer/home.nix
            nixvim.homeManagerModules.nixvim
            plasma-manager.homeManagerModules.plasma-manager
          ];
          extraSpecialArgs = {
            inherit inputs;
            inherit devenv;
            inherit nixvim;
            unstablePkgs = unstable.legacyPackages.x86_64-linux;
          };
        };

        eosgamer = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
          modules = [
            ./hosts/eosgamer/home.nix
            nixvim.homeManagerModules.nixvim
          ];
          extraSpecialArgs = {
            inherit inputs;
            #    inherit devenv;
            inherit nixvim;
            unstablePkgs = unstable.legacyPackages.x86_64-linux;
          };
        };

        silverblue = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
            #config.cudaSupport = true;
          };
          modules = [
            ./hosts/silverblue/home.nix
            nixvim.homeManagerModules.nixvim
            #plasma-manager.homeManagerModules.plasma-manager
          ];
          extraSpecialArgs = {
            inherit inputs;
            #    inherit devenv;
            inherit nixvim;
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
            i3mod = "Control";
            unstablePkgs = unstable.legacyPackages.x86_64-linux;
          };
        };
      };
    };
}
