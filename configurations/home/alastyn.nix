{
  flake,
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
    homeDirectory = lib.mkDefault "/home/alastyn";
    stateVersion = "24.11";
  };
}
