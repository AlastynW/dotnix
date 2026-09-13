# This is your nixos configuration.
# For home configuration, see /modules/home/*
{
  flake,
  pkgs,
  lib,
  ...
}:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{

  # Set your time zone.
  time.timeZone = lib.mkDefault "Europe/Paris";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    # Prevent installing all glibc supported locales
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "fr_FR.UTF-8/UTF-8"
    ];

    extraLocaleSettings = {
      LC_ADDRESS = "fr_FR.UTF-8";
      LC_IDENTIFICATION = "fr_FR.UTF-8";
      LC_MEASUREMENT = "fr_FR.UTF-8";
      LC_MONETARY = "fr_FR.UTF-8";
      LC_NAME = "fr_FR.UTF-8";
      LC_NUMERIC = "fr_FR.UTF-8";
      LC_PAPER = "fr_FR.UTF-8";
      LC_TELEPHONE = "fr_FR.UTF-8";
      LC_TIME = "fr_FR.UTF-8";
    };
  };

  # Autorise les paquets non-libres (nvidia, vscode, discord, brave, ...) sur
  # les deux hôtes -- avant ceci n'était réglé que sur victus, donc raspberry
  # aurait échoué à builder le même profil home-manager (vscode/discord/...).
  nixpkgs.config.allowUnfree = true;

  # nixpkgs.config.allowUnfree ne s'applique qu'aux évaluations passant par
  # la config système/flake (nixos-rebuild, home-manager, etc.). `nix-shell`
  # classique évalue nixpkgs séparément et l'ignore -- il faut donc aussi
  # cette variable d'env pour que `nix-shell -p <paquet-non-libre>` marche.
  environment.sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";

  # These users can add Nix caches.
  nix.settings.trusted-users = [
    "root"
    "@wheel"
  ];

  # Corrige ponctuellement wayland-protocols (trop ancien dans notre
  # nixpkgs release-26.05 pour Hyprland v0.56.0) sans faire suivre tout
  # Hyprland sur un autre nixpkgs — voir overlays/wayland-protocols.nix et
  # le commentaire sur l'input hyprland dans flake.nix.
  nixpkgs.overlays = [
    self.overlays.wayland-protocols
    self.overlays.linux-firmware-pin
  ];

  # Enable the OpenSSH service on every NixOS
  services.openssh.enable = true;
  # Enable the fwupd service on every NixOS
  services.fwupd.enable = true;

  # Filet de sécurité mémoire : swap configuré par machine (voir
  # configuration.nix de chaque hôte), pas ici, car la bonne solution dépend
  # du support de stockage : swapfile disque sur victus (NVMe, largement
  # assez de place), zram sur raspberry (carte SD -> éviter l'usure d'un
  # swapfile permanent).
}
