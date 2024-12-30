{ pkgs, ... }:
{
  colorschemes.vscode = {
    enable = pkgs.lib.mkDefault true;
  };
}
