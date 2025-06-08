{
  flake,
  pkgs,
  lib,
  ...
}:
let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    self.homeModules.default
  ];

  home = {
    username = "alastyn";
    homeDirectory = lib.mkDefault "/${if pkgs.stdenv.isDarwin then "Users" else "home"}/alastyn";
    stateVersion = "24.11";
  };
}
