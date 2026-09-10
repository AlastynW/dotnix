# Palette officielle Catppuccin Macchiato : https://catppuccin.com/palette
# (remplace l'ancienne palette Dracula pour unifier avec le reste de l'OS —
# modules/home/themes/catpuccin/{waybar,swaylock,hypr}/*.nix codent déjà ces
# mêmes couleurs en dur, et modules/home/neovim/nixvim.nix utilise désormais
# colorschemes.catppuccin.settings.flavour = "macchiato". Ce fichier est le
# seul consommé par kitty.nix et mako.nix (via flake.config.theme.xcolors),
# donc ce changement suffit à retinter tout le reste de l'OS.
rec {

  background = "24273a"; # base
  foreground = "cad3f5"; # text
  selection-background = "f4dbd6"; # rosewater (cf. kitty selection_background)
  selection-foreground = background; # base (cf. kitty selection_foreground)
  comment = overlay0;

  # Ansi mapping (identique à https://github.com/catppuccin/kitty/blob/main/themes/macchiato.conf)
  color0 = bg-light; # surface1
  color1 = red;
  color2 = green;
  color3 = yellow;
  color4 = blue;
  color5 = pink;
  color6 = cyan; # teal
  color7 = subtext1;
  color8 = bg-lighter; # surface2
  color9 = red;
  color10 = green;
  color11 = yellow;
  color12 = blue;
  color13 = pink;
  color14 = cyan;
  color15 = subtext0;

  # Base colors (surfaces Catppuccin Macchiato)
  bg-lighter = "5b6078"; # surface2
  bg-light = "494d64"; # surface1
  bg-darker = "181926"; # crust
  bg-dark = "1e2030"; # mantle

  subtext1 = "b8c0e0";
  subtext0 = "a5adcb";
  overlay2 = "939ab7";
  overlay1 = "8087a2";
  overlay0 = "6e738d";

  white = foreground; # pas de "blanc pur" dans Catppuccin ; on retombe sur le texte

  red = "ed8796";
  light-red = red; # Macchiato ne distingue pas les variantes "light" par accent

  green = "a6da95";
  light-green = green;

  yellow = "eed49f";
  light-yellow = yellow;

  blue = "8aadf4";
  light-blue = "b7bdf8"; # lavender

  pink = "f5bde6";
  light-pink = pink;

  cyan = "8bd5ca"; # teal
  light-cyan = "91d7e3"; # sky

  orange = "f5a97f"; # peach
  purple = "c6a0f6"; # mauve

}