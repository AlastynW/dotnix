{ lib, ... }:
let
  colors = import ./colors.nix;
  colorlib = import ../color-utils.nix { inherit lib; };
in
rec {
  theme = {
    # RRGGBB
    colors = colors;
    # #RRGGBB (réutilise colorlib.x plutôt que de réimplémenter le même
    # préfixage : `_: colorlib.x` curried donne bien `name -> value ->
    # résultat`, ce que mapAttrs attend)
    xcolors = builtins.mapAttrs (_: colorlib.x) colors;
    # rgba(,,,) colors (css)
    rgbaColors = lib.mapAttrs (_: colorlib.rgba) colors;
  };

}
