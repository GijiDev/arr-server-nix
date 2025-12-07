{
  inputs = {
    # Having troubles with upstream jellyfin
    # > Illegal instruction (core dumped)
    # Pin to last known good version
    nixpkgs.url = "github:NixOS/nixpkgs?rev=6158d9170f0c55f07123559161447f657dc9f887";

    flake-utils.url = "github:numtide/flake-utils";

    nixarr = {
      url = "github:GijiDev/nixarr";
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
      inputs = {
        nixpkgs.follows = "nixpkgs";
        gomod2nix.follows = "gomod2nix";
        flake-utils.follows = "flake-utils";
      };
    };

    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs = {
        # specifically don't follow nixpkgs - depends on older version
        flake-utils.follows = "flake-utils";
      };
    };
  };
  outputs =
    inputs@{
      nixpkgs,
      nixarr,
      ...
    }:
    {
      nixosConfigurations.arr = nixpkgs.lib.nixosSystem {
        specialArgs = inputs;
        modules = [
          nixarr.nixosModules.default
          ./configuration.nix
        ];
      };
    };
}
