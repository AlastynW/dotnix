{ pkgs, ... }:
{
  imports = [
    ./hypr
    ./swaylock.nix
    ./waybar
    ./cava.nix
  ];

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # Fonts
    nerd-fonts._0xproto
    nerd-fonts.droid-sans-mono
    font-awesome
  ];
}
