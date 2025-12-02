# /etc/nixos/flake.nix
# Modern, reproducible NixOS configuration using flakes
{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    # Home manager for user-level config (optional but recommended)
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Rust toolchain management
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Nix User Repository (for extra packages)
    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, fenix, nur, ... }@inputs:
  let
    system = "x86_64-linux";
    
    # Stable packages
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    
    # Unstable packages overlay (for bleeding edge)
    unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
    
  in {
    nixosConfigurations = {
      # Desktop / workstation
      archon = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs unstable; };
        modules = [
          ./configuration.nix
          
          # NUR overlay
          { nixpkgs.overlays = [ nur.overlays.default ]; }
          
          # Fenix (Rust) overlay
          { nixpkgs.overlays = [ fenix.overlays.default ]; }
          
          # Home manager (optional)
          # home-manager.nixosModules.home-manager
          # {
          #   home-manager.useGlobalPkgs = true;
          #   home-manager.useUserPackages = true;
          #   home-manager.users.YOUR_USERNAME = import ./home.nix;
          # }
        ];
      };
      
      # Headless server (Hetzner)
      hetzner = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs unstable; };
        modules = [
          ./configuration.nix
          {
            # Override for server
            services.xserver.enable = false;
            hardware.bluetooth.enable = false;
            # networking.hostName = "hetzner-box";
          }
        ];
      };
    };
  };
}
