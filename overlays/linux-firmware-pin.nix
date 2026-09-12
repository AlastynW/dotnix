{ flake, ... }:
let
  inherit (flake) inputs;
in
final: prev: {
  # Régression upstream linux-firmware 20260910 : le firmware DMCUB des APU
  # AMD Rembrandt/YELLOW_CARP (Radeon 680M, victus, PCI 06:00.0) ne charge
  # plus correctement -> spam "[drm] *ERROR* dc_dmub_srv_log_diagnostic_data"
  # + "dpia_query_hpd_status" et gel complet au boot (constaté le 2026-09-12,
  # cf. discussion CachyOS sur la 20260910-1 et linux-firmware!420 qui revert
  # dcn_3_1_4_dmcub.bin vers 0.0.246.0). amdgpu.dcdebugmask=0x10 (déjà présent
  # dans configurations/nixos/victus/configuration.nix) cible un bug DMCUB
  # différent (PSR) et ne corrige pas celui-ci.
  #
  # On épingle linux-firmware sur nixpkgs@09ae1c35 (release-26.05, commit du
  # 2026-09-08, version 20260810 = dernière connue bonne) en attendant le
  # revert upstream. À retirer une fois release-26.05 repassé sur un
  # linux-firmware corrigé (vérifier `nix eval .#nixosConfigurations.victus.
  # pkgs.linux-firmware.version` avant de supprimer cet overlay et l'input
  # nixpkgs-firmware-fix dans flake.nix).
  linux-firmware =
    inputs.nixpkgs-firmware-fix.legacyPackages.${final.stdenv.hostPlatform.system}.linux-firmware;
}
