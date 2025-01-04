# See /modules/nixos/* for actual settings
# This file is just *top-level* configuration.
{ flake, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    self.nixosModules.default
    self.nixosModules.gui
    ./configuration.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  # Enable home-manager for "alastyn" user
  home-manager.users."alastyn" = {
    imports = [ (self + /configurations/home/alastyn.nix) ];
  };

  # TODO: Move this to be shared with other config
  users.users.alastyn = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  nixpkgs.config.allowUnfree = true;
}
