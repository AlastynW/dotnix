{ ... }:
{
  imports = [
    ./workspaces.nix
    ./system-stats.nix
    ./clock-power.nix
  ];

  programs.waybar.settings.mainBar = {
    layer = "top";
    position = "top";
    height = 30;
    margin-top = 5;

    # "fixed-center": false

    modules-left = [
      "custom/launcher"
      "hyprland/workspaces"
      "tray"
      "hyprland/submap"
      "custom/cava-internal"
    ];
    modules-center = [ "clock" ];
    modules-right = [
      "backlight"
      "pulseaudio"
      "hyprland/language"
      "temperature"
      "memory"
      "battery"
      "network"
      "custom/power"
    ];
  };
}
