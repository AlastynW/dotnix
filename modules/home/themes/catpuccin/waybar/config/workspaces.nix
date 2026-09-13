# Modules du groupe "gauche" : workspaces, submap, tray, launcher, visualiseur audio.
{
  lib,
  pkgs,
  ...
}:
{
  programs.waybar.settings.mainBar = {
    "hyprland/workspaces" = {
      # Enable scroll in workspaces modules
      format = "{icon}";
      sort-by-number = true;
      active-only = false;
      on-scroll-up = "${pkgs.hyprland}/bin/hyprctl dispatch workspace e+1";
      on-scroll-down = "${pkgs.hyprland}/bin/hyprctl dispatch workspace e-1";
      on-click = "activate";
      format-icons = {
        "1" = "";
        "2" = "";
        "3" = "";
        "4" = "";
        "5" = "";
        "6" = "6";
        "7" = "7";
        "8" = "8";
        "9" = "9";
        "10" = "10";
        urgent = "";
        focused = "";
        default = "";
      };
    };

    "custom/cava-internal" = {
      exec = "${lib.getExe pkgs.cava} | ${lib.getExe pkgs.gnused} -u 's/;//g;s/0/▁/g;s/1/▂/g;s/2/▃/g;s/3/▄/g;s/4/▅/g;s/5/▆/g;s/6/▇/g;s/7/█/g;'";
      format = "{}";
      tooltip = false;
      on-click = "";
      output = "all";
      # cava's audio thread can lose a startup race when two instances
      # (one per monitor bar) grab the PulseAudio/PipeWire source at the
      # same time; the exec then exits and waybar never restarts it. Have
      # waybar respawn the module so it recovers on its own.
      restart-interval = 2;
    };

    "hyprland/submap" = {
      format = "<span style=\"italic\">{}</span>";
    };

    "tray" = {
      icon-size = 14;
      spacing = 5;
    };

    "custom/launcher" = {
      format = " ";
      on-click = "${lib.getExe pkgs.rofi} -modi drun -show drun -show-icons";
      tooltip = false;
    };
  };
}
