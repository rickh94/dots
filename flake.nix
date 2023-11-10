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
      url = "github:nixos/nixpkgs/nixos-23.05";
    };
    /* nixos-hardware.url = "github:nixos/nixos-hardware/master"; */
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devenv.url = "github:cachix/devenv/latest";

    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    codeium = {
      url = "github:jcdickinson/codeium.nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs@{ self, nixpkgs, darwin, home-manager, unstable, codeium, devenv }:
    let
      chosenfonts = [ "FiraCode" "Hack" "CascadiaCode" "Hasklig" "Lilex" "VictorMono" "Hermit" ];
    in
    {
      nixpkgs.config.allowUnfree = true;

      # NIXOS HOST
      nixosConfigurations = {
        beethoven = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          modules = [
            ./hosts/beethoven/configuration.nix
          ];
          specialArgs = { inherit nixpkgs; inherit inputs; inherit chosenfonts; };
        };

        nixvm = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          modules = [
            ./hosts/nixvm/configuration.nix
          ];
          specialArgs = { inherit nixpkgs; inherit chosenfonts; };
        };

        nixx86-vm = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/nixx86-vm/configuration.nix
          ];
          specialArgs = { inherit nixpkgs; inherit chosenfonts; };
        };

        nixarm-vm = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            ./hosts/nixarm-vm/configuration.nix
          ];
          specialArgs = { inherit nixpkgs; inherit chosenfonts; };
        };

        simplevm-arm = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            ./hosts/simplevm-arm/configuration.nix
          ];
          specialArgs = { inherit nixpkgs; inherit chosenfonts; };
        };

        simplevm = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/simplevm/configuration.nix
          ];
          specialArgs = { inherit nixpkgs; inherit chosenfonts; };
        };

        nixserver = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/nixserver/configuration.nix
          ];
          specialArgs = { inherit nixpkgs; inherit chosenfonts; inherit inputs; };
        };

        nixmc = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/nixmc/configuration.nix
          ];
          specialArgs = { inherit nixpkgs; inherit chosenfonts; inherit inputs; };
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
                extraSpecialArgs = { inherit devenv; };
              };
            }
          ];
          specialArgs = { inherit chosenfonts; inherit devenv; };
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
            overlays = [ codeium.overlays.x86_64-linux.default ];
          };
          modules = [
            ./hosts/beethoven/home.nix
          ];
          extraSpecialArgs = { inherit inputs; inherit chosenfonts; inherit devenv; i3mod = "Mod4"; };
        };

        chopin = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            overlays = [ codeium.overlays.x86_64-linux.default ];
          };
          modules = [
            ./hosts/chopin/home.nix
          ];
          extraSpecialArgs = { inherit inputs; inherit chosenfonts; inherit devenv; };
        };

        kali-arm = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "aarch64-linux";
            overlays = [ codeium.overlays.aarch64-linux.default ];
          };
          modules = [
            ./hosts/kali/home.nix
          ];
          extraSpecialArgs = { inherit inputs; inherit chosenfonts; inherit devenv; };
        };

        kali-x86 = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            overlays = [ codeium.overlays.x86_64-linux.default ];
          };
          modules = [
            ./hosts/kali/home.nix
          ];
          extraSpecialArgs = { inherit inputs; inherit chosenfonts; inherit devenv; };
        };

        nixvm = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            overlays = [ codeium.overlays.x86_64-linux.default ];
          };
          modules = [ ./hosts/nixvm/home.nix ];
          extraSpecialArgs = { inherit inputs; inherit chosenfonts; inherit devenv; i3mod = "Control"; };
        };

        nixx86-vm = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
          };
          modules = [ ./hosts/nixx86-vm/home.nix ];
          extraSpecialArgs = { inherit inputs; inherit chosenfonts; inherit devenv; i3mod = "Control"; };
        };

        nixarm-vm = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-linux;
          modules = [ ./hosts/nixarm-vm/home.nix ];
          extraSpecialArgs = { inherit inputs; inherit chosenfonts; inherit devenv; i3mod = "Control"; };
        };

        simplevm = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [ ./hosts/simplevm/home.nix ];
          extraSpecialArgs = { inherit inputs; inherit chosenfonts; inherit devenv; i3mod = "Control"; };
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
