{
  flake,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (flake) inputs;
  inherit (inputs) self;
in
let
  cursor = "Bibata-Modern-Classic-Hyprcursor";
  cursorPackage = self.packages.${pkgs.stdenv.hostPlatform.system}.bibata-hyprcursor;

  # Même correctif que modules/nixos/gui/hyprland.nix : le flake Hyprland
  # construit ses packages avec sa propre instance de pkgs, donc l'overlay
  # wayland-protocols de notre `pkgs` ne l'atteint pas sans `.override`.
  system = pkgs.stdenv.hostPlatform.system;
  hyprlandPkg = flake.inputs.hyprland.packages.${system}.hyprland.override {
    wayland-protocols = pkgs.wayland-protocols;
  };
in
{
  imports = [
    ./hyprpaper.nix
    ./keybinds.nix
    ./settings.nix
  ];

  xdg.dataFile."icons/${cursor}".source = "${cursorPackage}/share/icons/${cursor}";

  home.pointerCursor = {
    gtk.enable = true;
    package = cursorPackage;
    name = cursor;
    size = 16;
  };

  gtk = {
    enable = true;

    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Grey-Darkest";
    };

    # 26.05 : le défaut de gtk.gtk4.theme est passé de config.gtk.theme à
    # null. On fixe explicitement l'ancien comportement (thème GTK3 aussi
    # appliqué aux apps GTK4) plutôt que de dépendre de home.stateVersion.
    gtk4.theme = config.gtk.theme;

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    font = {
      name = "Sans";
      size = 11;
    };
  };

  home.sessionVariables = {
    # upscale steam
    GDK_SCALE = "1";
  };

  # enable hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprlandPkg;
    systemd.variables = [ "--all" ];
    plugins = [
      (flake.inputs.hy3.packages.${system}.hy3.override { hyprland = hyprlandPkg; })
    ];

    # 26.05 : le défaut est passé de "hyprlang" à "lua". Tout ce dépôt
    # (extraConfig, settings.*) est écrit en syntaxe hyprlang classique ;
    # basculer en Lua casserait tout ce qui suit. On fixe explicitement.
    configType = "hyprlang";
  };
}
