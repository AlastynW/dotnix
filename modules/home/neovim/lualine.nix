{ pkgs, ... }:
{
  plugins.lualine = {
    enable = pkgs.lib.mkDefault true;
    globalstatus = pkgs.lib.mkDefault true;
    theme = pkgs.lib.mkDefault "vscode";
    disabledFiletypes.statusline = [ "alpha" ];
    sections = {
      lualine_x = [ "filetype" ];
    };
  };
}
