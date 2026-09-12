{ flake, ... }:
final: prev: {
  # Hyprland v0.56.0 exige wayland-protocols >= 1.49 ; notre nixpkgs
  # release-26.05 (figé mai 2026) n'a que la 1.48 (sortie début avril 2026,
  # la 1.49 est sortie le 7 juin 2026, après le fork de la branche stable).
  # Bump ciblé de ce seul paquet plutôt que de faire suivre tout Hyprland
  # sur un nixpkgs différent du nôtre (ce qui avait causé un tout autre bug :
  # un split ABI libstdc++ entre hyprtoolkit et hyprland-guiutils).
  wayland-protocols = prev.wayland-protocols.overrideAttrs (old: {
    version = "1.49";
    src = prev.fetchurl {
      url = "https://gitlab.freedesktop.org/wayland/wayland-protocols/-/releases/1.49/downloads/wayland-protocols-1.49.tar.xz";
      hash = "sha256-7EyPdJQtbf96zotM5HZPDvn/YYqTXZdOp37e4q0kCxQ=";
    };
    # Si le build échoue sur un patch qui ne s'applique plus (rare pour ce
    # paquet, ce ne sont que des fichiers XML de protocole), videz `patches`
    # ici : patches = [ ];
  });
}
