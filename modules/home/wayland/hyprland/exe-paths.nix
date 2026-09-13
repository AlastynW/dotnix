# Chemins des binaires utilisés dans les keybinds/settings Hyprland
# (keybinds.nix, settings.nix). Centralisé ici pour éviter de répéter les
# mêmes lib.getExe/chemins dans les deux fichiers.
{ pkgs, lib }:
{
  amixer = "${pkgs.alsa-utils}/bin/amixer"; # alsa-utils expose multiple binaries
  brightnessctl = lib.getExe pkgs.brightnessctl; # remplace `light`, retiré de nixpkgs (26.05)
  cliphist = lib.getExe pkgs.cliphist;
  grim = lib.getExe pkgs.grim;
  kitty = lib.getExe pkgs.kitty;
  notify-send = lib.getExe pkgs.libnotify;
  playerctl = lib.getExe pkgs.playerctl;
  rofi = lib.getExe pkgs.rofi; # rofi-wayland a été fusionné dans rofi (26.05)
  slurp = lib.getExe pkgs.slurp;
  swaylock-effects = lib.getExe pkgs.swaylock-effects;
  wl-copy = "${pkgs.wl-clipboard}/bin/wl-copy"; # wl-clipboard expose multiple binaries
  wl-paste = "${pkgs.wl-clipboard}/bin/wl-paste";
  wtype = lib.getExe pkgs.wtype; # Allow pasting to gui application by simulating keyboard inputs
}
