{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    nixarr = {
      url = "github:rasmus-kirk/nixarr";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    gomod2nix = {
      url = "github:tweag/gomod2nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    transmission-protonvpn = {
      url = "github:pborzenkov/transmission-protonvpn-nat-pmp";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.gomod2nix.follows = "gomod2nix";
    };
  };
  outputs =
    inputs@{
      nixpkgs,
      nixarr,
      ...
    }:
    {
      nixosConfigurations.hashida-itaru = nixpkgs.lib.nixosSystem {
        specialArgs = inputs;
        modules = [
          ./configuration.nix
          nixarr.nixosModules.default
        ];
      };
    };
}
