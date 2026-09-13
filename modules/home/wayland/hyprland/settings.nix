# Settings Hyprland structurés (wayland.windowManager.hyprland.settings) :
# variable $mainMod, layout, exec-once, binds clipboard, claviers.
{
  pkgs,
  lib,
  ...
}:
let
  exe = import ./exe-paths.nix { inherit pkgs lib; };

  mainMod = "SUPER";

  clipboard = {
    paste = "${exe.cliphist} list | ${exe.rofi} -dmenu -theme /etc/nixos/modules/home/rofi/clipboard/config.rasi | ${exe.cliphist} decode | ${exe.wl-copy} && ${exe.wtype} -M ctrl v -m ctrl";
    wipe = "${exe.cliphist} wipe && ${exe.notify-send} \"Cleared clipboard\"";
  };
in
{
  wayland.windowManager.hyprland.settings = {
    "$mainMod" = mainMod;
    general = {
      layout = "hy3";
    };
    # Exec configuration
    exec-once = [
      "${exe.wl-paste} --type text --watch ${exe.cliphist} store" # cliphist retains only text inputs
    ];
    bind = [
      # Clipboard
      "CTRL SHIFT, V, exec, ${clipboard.paste}"
      "$mainMod SHIFT, V, exec, ${clipboard.wipe}"
    ];
    device = [
      {
        name = "g915-keyboard-keyboard";
        kb_layout = "fr";
        kb_variant = "";
      }
      {
        name = "logitech-usb-receiver-keyboard";
        kb_layout = "fr";
        kb_variant = "";
      }
      {
        name = "nuphy-nuphy-halo96-v2-keyboard";
        kb_options = "altwin:swap_alt_win";
      }
    ];
  };
}
