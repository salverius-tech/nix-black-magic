{
  description = "Black Magic";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      commonModules = [
        ./common/base-config.nix
        ./common/base-packages.nix
        ./common/build-image.nix
      ];
    in
    {
      nixosConfigurations = {
        build-qcow2-development = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = commonModules ++ [
            ./dev/development.nix
            ./dev/packages.nix
          ];
        };
        build-qcow2-production = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = commonModules ++ [
            ./prod/production.nix
            ./prod/packages.nix
          ];
        };
      };
    };
}