# ===========================================================================
# Plugins hors périmètre NixVim : ajoutés bruts via extraPlugins.
# ===========================================================================
{ pkgs, ... }:
{
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      pname = "typst-preview-nvim";
      version = "unstable";
      src = pkgs.fetchFromGitHub {
        owner = "chomosuke";
        repo = "typst-preview.nvim";
        rev = "master"; # branche par défaut réelle (vérifié), à épingler sur un commit précis en prod
        hash = "sha256-UTugVfydwGTmf5RomQ0R72Yf6fSz8gGeY/fg51qW454="; # obtenu via l'erreur de hash mismatch
      };
    })
    (pkgs.vimUtils.buildVimPlugin {
      pname = "hept-vim";
      version = "unstable";
      src = pkgs.fetchFromGitHub {
        owner = "Fymyte";
        repo = "hept.vim";
        rev = "master"; # idem, branche par défaut réelle
        hash = "sha256-flJKnjp8YEhvFlbYZXb/InxdM6ZDV9+ZxvJvmNjPP8U=";
      };
    })
    # peek.nvim (preview markdown) nécessite `deno task build:fast` au build.
    # C'est faisable avec buildVimPlugin + nativeBuildInputs=[pkgs.deno], mais
    # volontairement omis ici pour garder un premier `nixos-rebuild` fiable.
    # Alternative plus simple à déclarer : pkgs.vimPlugins.markdown-preview-nvim.
  ];

  # Un seul extraConfigLua : Nix rejette deux définitions du même attribut,
  # donc tout le Lua "libre" (vim.filetype.add + setup des plugins ajoutés
  # via extraPlugins) est regroupé ici.
  extraConfigLua = ''
    vim.filetype.add({
      extension = {
        mdx = "markdown",
        vhd = "vhdl",
        vhdl = "vhdl",
        cu = "c",
      },
    })

    -- typst-preview.nvim (lazy=false, opts={})
    require("typst-preview").setup({})
  '';
}
