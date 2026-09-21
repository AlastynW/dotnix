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

    # (2026-09-21) `finegrained = false` ne suffit PAS à couper le Runtime D3
    # power management : cette option n'ajoute un paramètre modprobe que
    # lorsqu'elle vaut `true` (voir modules/hardware/video/nvidia.nix de
    # nixpkgs) ; à `false` le driver retombe sur SON propre défaut, qui active
    # RTD3 fine-grained (confirmé via `cat /proc/driver/nvidia/gpus/*/power`
    # -> "Runtime D3 status: Enabled (fine-grained)" alors même que l'option
    # nix est à false). Or le port HDMI est câblé en dur sur le GPU NVIDIA
    # (aucun MUX), ce que NVIDIA documente comme incompatible avec RTD3 : le
    # lien PCIe se met en veille et le premier modeset (au lancement de
    # Hyprland) le réveille en catastrophe -> écran externe "connected" côté
    # DRM mais aucune image réelle (2 erreurs PCIe "BadTLP" dans le journal du
    # boot, ~6s après le démarrage de Hyprland, pile au moment du commit du
    # mode sur HDMI-A-1). Le débranchement/rebranchement du câble ne fait que
    # forcer un nouveau hotplug une fois le GPU déjà réveillé par autre chose.
    # On désactive donc RTD3 explicitement plutôt que de compter sur
    # `finegrained`.
    moduleParams.nvidia.NVreg_DynamicPowerManagement = "0x00";

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      # reverseSync ne configure que Xorg (xrandr --setprovideroutputsource +
      # Inactive Device) : aucun effet sur une session Wayland/Hyprland native
      # (vérifié dans le module nixpkgs). Inutile ici, mais pas la cause du
      # problème de sortie HDMI ci-dessus.
      reverseSync.enable = false;
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
  # Stockage Windows (dual-boot, partition BitLocker)
  # ===========================================================================
  # nvme0n1p3 (PARTUUID ci-dessous) est le vrai volume de données Windows,
  # chiffré BitLocker ; nvme0n1p4 (998M) n'est que la partition de
  # récupération Windows, pas les fichiers utilisateur. dislocker déchiffre
  # le volume en un fichier bloc virtuel, ensuite monté en NTFS classique
  # via ntfs-3g. Pas de montage automatique ni de clé stockée sur disque :
  # `mount-windows` la demande interactivement à chaque fois (saisie
  # masquée), et se relance avec sudo si besoin. Monté en lecture seule par
  # défaut — Windows avec démarrage rapide/hibernation activé peut corrompre
  # le volume si on écrit dessus depuis Linux pendant qu'il est hiberné.
  environment.systemPackages = with pkgs; [
    vim
    wget
    kitty

    dislocker
    ntfs3g

    (writeShellScriptBin "mount-windows" ''
      set -euo pipefail
      if (( EUID != 0 )); then exec sudo "$0" "$@"; fi

      PARTITION="/dev/disk/by-partuuid/06667eb1-b0aa-4fac-94f4-5b213d162690"
      BITLOCKER_MNT="/mnt/bitlocker"
      WINDOWS_MNT="/mnt/windows"

      if mountpoint -q "$WINDOWS_MNT"; then
        echo "Déjà monté sur $WINDOWS_MNT" >&2
        exit 0
      fi

      install -d -m 0700 "$BITLOCKER_MNT" "$WINDOWS_MNT"

      read -r -s -p "Clé de récupération BitLocker (48 chiffres, dashes ou espaces acceptés) : " RAW_KEY
      echo

      # Ne garde que les chiffres : tolère que la clé ait été collée avec des
      # espaces, des tirets à la mauvaise place, ou aucun séparateur, puis la
      # reformate elle-même au format attendu par dislocker (8 groupes de 6
      # chiffres séparés par des tirets).
      DIGITS="''${RAW_KEY//[^0-9]/}"
      if [[ ''${#DIGITS} -ne 48 ]]; then
        echo "Erreur : ''${#DIGITS} chiffres détectés, il en faut exactement 48. Vérifie la clé." >&2
        exit 1
      fi
      KEY=$(echo "$DIGITS" | sed -E 's/(.{6})(.{6})(.{6})(.{6})(.{6})(.{6})(.{6})(.{6})/\1-\2-\3-\4-\5-\6-\7-\8/')

      ${dislocker}/bin/dislocker -v -V "$PARTITION" -p"$KEY" -- "$BITLOCKER_MNT"
      ${ntfs3g}/bin/ntfs-3g -o ro "$BITLOCKER_MNT/dislocker-file" "$WINDOWS_MNT"

      echo "Monté en lecture seule sur $WINDOWS_MNT"
    '')

    (writeShellScriptBin "umount-windows" ''
      set -euo pipefail
      if (( EUID != 0 )); then exec sudo "$0" "$@"; fi

      umount "/mnt/windows" 2>/dev/null || true
      umount "/mnt/bitlocker" 2>/dev/null || true
      echo "Démonté."
    '')
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # networking.firewall.enable = false;
}
