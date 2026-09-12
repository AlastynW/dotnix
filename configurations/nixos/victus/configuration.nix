# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
#
# Harmonisé pour NixOS 26.05. Tout ce qui est déjà géré par le flake est
# volontairement absent d'ici (utilisateur "alastyn" -> ./default.nix ;
# pipewire/rtkit/xdg.portal/libinput/dconf/geoclue + Hyprland ->
# modules/nixos/gui/default.nix ; locale/timeZone/openssh/fwupd ->
# modules/nixos/default.nix). Regroupé par thème plutôt que dans l'ordre
# généré par nixos-generate-config.

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # ===========================================================================
  # Système / boot
  # ===========================================================================
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # nixpkgs.config.allowUnfree est réglé une seule fois pour les deux hôtes,
  # voir modules/nixos/default.nix.

  # This value determines the NixOS release from which the default settings
  # for stateful data were taken. Leave it at the release of the first
  # install of this system ; ne PAS le faire suivre les mises à jour.
  system.stateVersion = "26.05"; # Did you read the comment?

  # ===========================================================================
  # Swap
  # ===========================================================================
  # Swapfile permanent sur disque (ext4, / a ~36G de libre sur les 198G du
  # NVMe) plutôt que du zram qui grignote la RAM elle-même. Remplace
  # l'ancien zramSwap (déplacé sur raspberry, voir modules/nixos/default.nix).
  swapDevices = [
    {
      device = "/var/swapfile";
      size = 8192; # MiB (~8G, ajustable)
    }
  ];

  # ===========================================================================
  # Réseau
  # ===========================================================================
  networking = {
    hostName = "victus";
    networkmanager.enable = true;
    # wireless.enable = true; # via wpa_supplicant, inutile avec NetworkManager
  };

  # ===========================================================================
  # Localisation / clavier
  # ===========================================================================
  # NuPhy Halo96 V2 non modifié = ANSI US standard (firmware d'usine, aucun
  # remap QMK/VIA). Aligné sur le défaut déjà utilisé par Hyprland pour les
  # claviers non listés explicitement (voir modules/home/wayland/hyprland/hyprland.nix) :
  # "intl" permet toujours les accents français via touches mortes (' + e = é).
  # Les claviers AZERTY physiques (G915, dongle Logitech) restent en "fr" via
  # les overrides par périphérique de Hyprland, qui ne dépendent pas de ceci.
  services.xserver.xkb = {
    layout = "us";
    variant = "intl";
  };
  console.keyMap = "us";

  # ===========================================================================
  # GPU (nvidia, hybride PRIME) + Xorg/Wayland
  # ===========================================================================
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics.enable = true;

  # Contourne un bug connu du firmware DMUB sur les APU AMD Rembrandt/YELLOW_CARP
  # (erreurs "[drm] *ERROR* Error queueing DMUB command: status=2" -> gel complet
  # au boot). dcdebugmask=0x10 désactive le PSR, seule fonctionnalité en cause ;
  # n'affecte pas le fonctionnement du GPU AMD ni du hybride PRIME NVIDIA.
  boot.kernelParams = [ "amdgpu.dcdebugmask=0x10" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    # TEMPORAIRE (test diagnostic gel au boot, cf. conversation du 2026-09-12) :
    # finegrained + reverseSync déclenchent une transition ACPI power-state tôt
    # au boot qui semble percuter le firmware DMUB amdgpu (gel en ~3s, malgré
    # dcdebugmask=0x10 déjà actif). On repasse à false pour confirmer la cause
    # avant de chercher une vraie solution. À remettre à `true` après le test.
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true; # accessible via `nvidia-settings`

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      reverseSync.enable = false; # TEMPORAIRE, voir commentaire ci-dessus
      allowExternalGpu = false;
      # À revérifier après réinstallation via `lspci | grep -E "VGA|3D"` :
      # les Bus ID PCI peuvent changer même sur le même matériel physique.
      nvidiaBusId = "PCI:1:0:0";
      amdgpuBusId = "PCI:6:0:0";
    };

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # ===========================================================================
  # Périphériques
  # ===========================================================================
  services.printing.enable = true; # CUPS
  services.pcscd.enable = true; # smart card / Yubikey

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # ===========================================================================
  # Virtualisation
  # ===========================================================================
  virtualisation.docker.enable = true;

  # ===========================================================================
  # Paquets système (le gros du reste passe par home-manager)
  # ===========================================================================
  environment.systemPackages = with pkgs; [
    vim
    wget
    kitty
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # networking.firewall.enable = false;
}
