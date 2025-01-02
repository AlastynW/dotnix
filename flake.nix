{
  description = "A home-manager template providing useful tools & settings for Nix-based development";

  inputs = {
    # Principle inputs (updated by `nix run .#update`)
    nixpkgs.url = "github:nixos/nixpkgs/release-24.11";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-unified.url = "github:srid/nixos-unified";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    zen-browser.url = "github:omarcresp/zen-browser-flake";

    hyprland.url = "github:hyprwm/Hyprland?submodules=1&ref=v0.45.0";
    hy3 = {
      url = "github:outfoxxed/hy3?ref=hl0.45.0";
      inputs.hyprland.follows = "hyprland";
    };

    # Software inputs
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.inputs.flake-parts.follows = "flake-parts";
  };

  # Wired using https://nixos-unified.org/autowiring.html
  outputs = {
    nixvim,
    nixpkgs,
    flake-parts,
    ...
  } @ inputs:
  let inputs.nixos-unified.lib.mkFlake = {
      inherit inputs;
      root = ./.;
    };
  mkPkgs = system:
      import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      imports = [
        inputs.flake-parts.flakeModules.easyOverlay
      ];

      perSystem = {
        system,
        config,
        ...
      }: let
        nixvimLib = nixvim.lib.${system};
        nixvim' = nixvim.legacyPackages.${system};
        nixvimModule = {
          pkgs = mkPkgs system;
          module = import ./config;
          extraSpecialArgs = {
          };
        };
        jeezyvim = nixvim'.makeNixvimWithModule nixvimModule;
      in {
        checks = {
          default = nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;
        };

        packages = {
          inherit jeezyvim;
          default = jeezyvim;
        };

        overlayAttrs = {
          inherit (config.packages) jeezyvim;
        };
      };
   };
}
