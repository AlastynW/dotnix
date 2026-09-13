/*
  Traduction déclarative (NixVim) de https://github.com/MrVyM/Nvim-Config

  Le dépôt d'origine est une config LazyVim (init.lua -> require("lazy").setup({
  spec = { "LazyVim/LazyVim", import = "plugins" } })). Répliquer la
  distribution LazyVim entière (which-key, flash.nvim, mini.icons, etc.) n'a
  pas de sens en NixVim : ci-dessous, tout ce qui était une PERSONNALISATION
  explicite du dépôt (core/settings.lua, core/keymaps.lua, core/autocmd.lua,
  et chaque fichier de lua/plugins/*.lua) est traduit fidèlement. Mason +
  mason-lspconfig sont remplacés par la gestion Nix-native des serveurs LSP
  de NixVim (plugins.lsp.servers.*), ce qui est plus idiomatique et évite de
  télécharger les binaires LSP à l'exécution.

  Omissions volontaires (voir commentaires dans extra.nix) :
    - peek.nvim (preview markdown) : nécessite un build via deno, non
      trivialement déclaratif -> proposition alternative en commentaire.
    - Le "chrome" LazyVim par défaut (which-key, flash, mini.icons, la
      dashboard de démarrage, etc.) n'est pas reconstruit à l'identique.

  Découpé par domaine (voir README.MD) : chaque fichier ci-dessous ne
  définit que les clés qui le concernent, fusionnées par le système de
  modules NixVim exactement comme si tout était resté dans un seul fichier.
*/
{
  imports = [
    ./options.nix
    ./autocmds.nix
    ./keymaps.nix
    ./diagnostics.nix
    ./extra.nix
    ./plugins/editor.nix
    ./plugins/completion.nix
    ./plugins/lsp-dap.nix
    ./plugins/ui.nix
    ./plugins/git-todo.nix
  ];
}
