{ pkgs, ... }:
{
  imports = [
    ./hypr
    ./swaylock.nix
    ./waybar
    ./cava.nix
  ];

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # Fonts
    # `nerdfonts` (méta-paquet "toutes les polices") a été retiré de
    # nixpkgs : Nerd Fonts v3 a scindé chaque police dans son propre dépôt
    # upstream, donc nixpkgs expose désormais nerd-fonts.<nom> séparément.
    # Hack Nerd Font est explicitement mentionnée (en commentaire) dans
    # waybar/style.css, c'est celle-ci qu'on installe.
    nerd-fonts.hack
    font-awesome
  ];
}
