{
  description = "A home-manager template providing useful tools & settings for Nix-based development";

  inputs = {
    # Principle inputs (updated by `nix run .#update`)
    nixpkgs.url = "github:nixos/nixpkgs/release-26.05";

    # Épinglage temporaire de linux-firmware, voir overlays/linux-firmware-pin.nix.
    # NE PAS mettre à jour via `nix run .#update` tant que le revert upstream
    # n'est pas passé (vérifier la version de linux-firmware sur release-26.05).
    nixpkgs-firmware-fix.url = "github:nixos/nixpkgs/09ae1c3517b71500082b5fd39d02afb6c9ebfb45";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-unified.url = "github:srid/nixos-unified";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    # v0.45.2-b (nov. 2024) ne compilait plus contre nixpkgs 26.05 : le
    # CMakeLists de sa dépendance aquamarine 0.5.0 ne trouvait plus `gbm` via
    # pkg-config (réagencement mesa/gbm entre-temps). hy3 doit toujours
    # cibler EXACTEMENT la même release Hyprland (ABI de plugin strict) :
    # vérifiez https://github.com/outfoxxed/hy3/releases avant de rebumper.
    #
    # nixpkgs.follows RESTAURÉ ici : sans lui, hyprtoolkit et
    # hyprland-guiutils (deux sous-composants du flake Hyprland) finissaient
    # par être liés contre deux libstdc++ différentes (leur propre
    # flake.lock interne n'est pas parfaitement synchronisé sur ce tag),
    # d'où un crash de link "undefined reference ... GLIBCXX_3.4.36". En
    # forçant TOUT le sous-arbre Hyprland sur NOTRE nixpkgs unique, tout
    # redevient cohérent. Ça réintroduit en revanche le souci de
    # wayland-protocols trop ancien (1.48 vs 1.49 requis) : corrigé
    # ponctuellement via overlays/wayland-protocols.nix plutôt que de
    # revenir au nixpkgs propre de Hyprland.
    hyprland.url = "github:hyprwm/Hyprland/v0.56.0";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    hy3 = {
      url = "github:outfoxxed/hy3?ref=hl0.56.0.1";
      inputs.hyprland.follows = "hyprland";
    };

    # Software inputs
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    # NixVim: used to build a fully declarative Neovim configuration
    # (replaces the old symlink to ~/Nvim-Config).
    # NB: on ne "follows" pas nixpkgs ici, nixvim est testé contre sa
    # propre révision de nixpkgs (recommandation officielle du projet).
    nixvim.url = "github:nix-community/nixvim/nixos-26.05";
  };

  # Wired using https://nixos-unified.org/autowiring.html
  outputs =
    inputs:
    inputs.nixos-unified.lib.mkFlake {
      inherit inputs;
      root = ./.;
    };
}
