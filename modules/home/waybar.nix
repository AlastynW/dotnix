{ pkgs, ... }:
{
  # Add hyprctl to waybar env : https://github.com/hyprwm/Hyprland/issues/1835
  systemd.user.services.waybar.Service.Environment = "PATH=/run/wrappers/bin:${pkgs.hyprland}/bin";

  # Waybar crashes instantly when Hyprland exits (dead Wayland socket). If we
  # relog fast, it burns through systemd's default restart burst (5 tries in
  # 10s) before the new Hyprland session re-exports WAYLAND_DISPLAY, and gets
  # stuck "failed" forever instead of coming back. Remove the burst limit and
  # slow the retries down so it just waits patiently for the new session.
  systemd.user.services.waybar.Unit.StartLimitIntervalSec = 0;
  systemd.user.services.waybar.Service.RestartSec = "2";

  programs.waybar = {
    enable = true;
    systemd.enable = true;
  };
}
