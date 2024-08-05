{
  description = "NixOS configuration with two or more channels";

  inputs = {
    nixpkgs-stable.url = "nixpkgs/nixos-23.11";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, ... }@inputs:
    let
      system = "x86_64-linux";
      overlay-stable = final: prev: {
        stable = import nixpkgs-stable {
          inherit system;
          config.allowUnfree = true;
        };

      };
    in {
      nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        inherit system;
        modules = [
          # Overlays-module makes "pkgs.unstable" available in configuration.nix
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-stable ]; })
          ./configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };
    };
}

