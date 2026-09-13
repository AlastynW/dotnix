# ===========================================================================
# Options globales (core/settings.lua)
# ===========================================================================
{ pkgs, ... }:
{
  globals.mapleader = ",";

  opts = {
    number = true;
    hlsearch = true;
    ignorecase = true;
    smartcase = true;
    showmatch = true;
    backup = false;
    wrap = false;
    cursorline = true;
    scrolloff = 10;
    mouse = ""; # souris désactivée, comme dans l'original
    termguicolors = true;
    expandtab = true;
    hidden = true;

    spell = true;
    spelllang = "fr";
    splitright = true;
    splitbelow = true;

    shell = "${pkgs.zsh}/bin/zsh"; # au lieu du chemin en dur /usr/bin/zsh
    winborder = "rounded";

    updatetime = 250;
  };

  clipboard.register = "unnamedplus";
}
