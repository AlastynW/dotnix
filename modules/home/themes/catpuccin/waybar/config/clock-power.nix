# Horloge, alimentation (verrouillage/déconnexion/redémarrage) et langue clavier.
{
  lib,
  pkgs,
  ...
}:
{
  programs.waybar.settings.mainBar = {
    "clock" = {
      format = "  {:%d/%m/%Y  %H:%M}";
      format-alt = "  {:%d/%m/%Y  %H:%M:%S}";
      interval = 1;
      tooltip-format = "<tt><small>{calendar}</small></tt>";

      calendar = {
        mode = "month";
        mode-mon-col = 3;
        weeks-pos = "right";
        on-scroll = 1;
        on-click-right = "mode";
        format = {
          months = "<span color='#ffead3'><b>{}</b></span>";
          days = "<span color='#ecc6d9'><b>{}</b></span>";
          weeks = "<span color='#99ffdd'><b>W{}</b></span>";
          weekdays = "<span color='#ffcc66'><b>{}</b></span>";
          today = "<span color='#ff6699'><b><u>{}</u></b></span>";
        };
      };
      actions = {
        on-click-right = "mode";
        on-click-forward = "tz_up";
        on-click-backward = "tz_down";
        on-scroll-up = "shift_up";
        on-scroll-down = "shift_down";
      };
    };

    "custom/power" = {
      format = "⏻";
      on-click = ''
        case "$(printf 'Lock\nLogout\nReboot\nShutdown' | ${lib.getExe pkgs.rofi} -dmenu -p Power)" in
          Lock) ${lib.getExe pkgs.swaylock-effects} -S ;;
          Logout) systemctl --user stop graphical-session.target && ${pkgs.hyprland}/bin/hyprctl dispatch exit ;;
          Reboot) systemctl reboot ;;
          Shutdown) systemctl poweroff ;;
        esac
      '';
      tooltip = false;
    };

    "hyprland/language" = {
      format = "  {short}";
    };
  };
}
