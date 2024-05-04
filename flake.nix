{
  description = "Black Magic";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
  };
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      commonModules = [
        ./common/base-config.nix
        ./common/base-packages.nix
        ./common/qcow.nix
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