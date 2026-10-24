{
  description = "Flake based NixOS + Home Manager setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    opencode.url = "github:anomalyco/opencode/v1.18.34";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";
    settings = import ./modules/settings.nix;
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in
  {
    # --- System configuration (NixOS) ---
    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs settings; };
      modules = [
        ./hosts/desktop/configuration.nix
        home-manager.nixosModules.home-manager
      ];
    };

    # --- Home configuration (standalone) ---
    homeConfigurations.${settings.user} = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { inherit inputs settings; };
      modules = [ ./modules/home/default.nix ];
    };
  };
}
