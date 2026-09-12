{
  flake,
  lib,
  pkgs,
  ...
}:
let
  inherit (flake.config.theme) xcolors;
in
{
  services.mako = {
    enable = true;

    # 26.05 : toutes ces clés sont passées sous settings.* (en kebab-case,
    # reflet direct des clés de mako.conf) plutôt qu'au niveau racine.
    settings = {
      sort = "-time";
      layer = "top";
      background-color = xcolors.background + "EF"; # Add opacity
      text-color = xcolors.selection-foreground;
      margin = toString 0;
      padding = toString 16;
      border-size = 0;
      border-radius = 12;
      icons = true;
      default-timeout = 30 * 1000; # 30s
    };

    extraConfig = ''
      text-alignment=center
      outer-margin=8

      [urgency=high]
      text-color=${xcolors.light-red}
      default-timeout=0
    '';
  };
  #icon-path=/usr/share/icons/Papirus-Dark
  #font=JetBrainsMono Nerd Font 10

}
