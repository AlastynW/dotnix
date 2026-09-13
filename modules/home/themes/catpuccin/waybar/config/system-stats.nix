# Modules de supervision système : CPU, mémoire, température, luminosité,
# batterie, réseau, audio.
{ ... }:
{
  programs.waybar.settings.mainBar = {
    "cpu" = {
      format = "﬙ {usage: >3}%";
    };

    "memory" = {
      format = " {: >3}%";
    };

    "temperature" = {
      format = "  {temperatureC}°C";
      critical-threshold = 80;
    };

    "backlight" = {
      device = "{icon} {percent: >3}%";
      format = "{percent}% {icon}";
      format-icons = [
        ""
        ""
      ];
    };

    "battery" = {
      format = "{icon} {capacity: >3}%";
      format-icons = [
        ""
        ""
        ""
        ""
        ""
      ];
      states = {
        warning = 30;
        critical = 15;
      };
    };

    "network" = {
      format = "⚠  Disabled";
      format-wifi = "  {essid}";
      format-ethernet = " {ifname}: {ipaddr}/{cidr}";
      format-disconnected = "⚠  Disconnected";
      max-length = 50;
    };

    "pulseaudio" = {
      scroll-step = 1;
      format = "{icon} {volume: >3}%";
      format-bluetooth = "{icon} {volume: >3}%";
      format-muted = " muted";
      format-icons = {
        headphones = "";
        handsfree = "";
        headset = "";
        phone = "";
        portable = "";
        car = "";
        default = [
          ""
          ""
        ];
      };
      on-click = "pavucontrol";
    };
  };
}
