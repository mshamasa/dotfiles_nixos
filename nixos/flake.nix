{
  description = "NixOS system setup";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      mangowm,
      home-manager,
      ...
    }:
    {
      nixosConfigurations.ms = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          mangowm.nixosModules.mango
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              sharedModules = [ mangowm.hmModules.mango ];
              users.ms = import ./home.nix;
              backupFileExtension = "backup";
            };
          }
        ];
      };
    };
}
