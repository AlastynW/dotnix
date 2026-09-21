{ ... }:
let
  left = ../backgrounds/squeleton.jpg; # eDP-1 (écran interne, à gauche)
  right = ../backgrounds/pleurs.jpg; # HDMI-A-1 (écran externe, à droite)
in
{
  # Le hyprpaper packagé par nixpkgs 26.05 (v0.8.4) est une réécriture qui a
  # abandonné la syntaxe `preload`/`wallpaper = mon,chemin` : ces directives
  # n'existent plus du tout dans le binaire (confirmé en lisant
  # src/config/ConfigManager.cpp sur github.com/hyprwm/hyprpaper). Sans
  # erreur ni log, `preload`/`wallpaper` étaient silencieusement ignorées et
  # hyprpaper démarrait sans fond d'écran ("Monitor X has no target"). La
  # nouvelle syntaxe est un bloc spécial `wallpaper { }` par moniteur.
  home.file.".config/hypr/hyprpaper.conf".text = ''
    wallpaper {
      monitor = eDP-1
      path = ${left}
    }
    wallpaper {
      monitor = HDMI-A-1
      path = ${right}
    }
  '';
}
