{ ... }:
{
  # Montage automatique des clés USB / disques externes branchés à chaud.
  # S'appuie sur services.udisks2 (activé côté système, voir
  # modules/nixos/gui/default.nix) pour le montage lui-même ; udiskie ne fait
  # qu'écouter les événements D-Bus et déclencher le montage + une icône dans
  # le tray waybar.
  services.udiskie = {
    enable = true;
    tray = "auto"; # cache l'icône quand il n'y a rien de monté
    notify = true;
    automount = true;
  };
}
