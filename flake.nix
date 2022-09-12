{
  description = "My Personal NixOS and Darwin System Flake Configuration";

  inputs = # All flake references used to build my NixOS setup. These are dependencies.
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # Nix Packages

      home-manager = { # User Package Management
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };

  # Function that tells my flake which to use and what do what to do with the dependencies.
  outputs = { self, nixpkgs, home-manager }@inputs:
    # Variables that can be used in the config files.
    let
      system = "x86_64-linux"; # System architecture
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true; # Allow proprietary software
      };
      lib = nixpkgs.lib;
      user = "file0";
    in {

      # Your custom packages and modifications
      overlays = { default = import ./overlays { inherit inputs; }; };

      # devShells = forAllSystems (system: {
      #   default = legacyPackages.${system}.callPackage ./shell.nix { };
      # });

      nixosConfigurations = { # NixOS configurations
        blade = lib.nixosSystem { # Laptop profile
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/common.nix
            ./hosts/blade
            ./nix.nix
            { nix.registry.nixpkgs.flake = nixpkgs; }
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit user; };
              home-manager.users.${user} = import ./modules;
            }
          ];
        };
      };
    };
}
