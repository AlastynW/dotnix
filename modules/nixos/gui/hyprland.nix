{ flake, pkgs, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
  system = pkgs.stdenv.hostPlatform.system;
  hyprlandPackages = inputs.hyprland.packages.${system};

  # Hyprland v0.56.0 exige wayland-protocols >= 1.49 (voir
  # overlays/wayland-protocols.nix), mais le flake Hyprland construit ses
  # packages avec sa PROPRE instance de pkgs (pkgsFor dans son flake.nix),
  # donc notre overlay sur `pkgs` ne l'atteint jamais : il faut ré-injecter
  # le correctif ici via `.override`.
  hyprland = hyprlandPackages.hyprland.override { wayland-protocols = pkgs.wayland-protocols; };
in
{

  imports = [
    self.inputs.hyprland.nixosModules.default
  ];

  environment.systemPackages = with pkgs; [
    pkgs.kitty
  ];

  programs.hyprland = {
    enable = true;
    # set the flake package
    package = hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage = hyprlandPackages.xdg-desktop-portal-hyprland.override {
      inherit hyprland;
      wayland-protocols = pkgs.wayland-protocols;
    };
  };
  # add hyprland to display manager sessions
  services.displayManager.sessionPackages = [
    hyprland
  ];
  security.pam.services.swaylock = { };

  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  # Fix mesa missmatch preventing Hyprland to start
  hardware.graphics.package =
    inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.mesa;

}
