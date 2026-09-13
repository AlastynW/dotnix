{ ... }:
{
  # ===========================================================================
  # Colorscheme (lua/plugins/colorscheme.lua)
  # ===========================================================================
  # Flavor aligné sur modules/home/themes/catpuccin/{waybar,swaylock,hypr}/*.nix
  # (couleurs Catppuccin Macchiato codées en dur côté bureau) plutôt que le
  # flavor par défaut du plugin ("mocha"), pour une cohérence visuelle avec
  # le reste du bureau. Le terminal (kitty) et les notifications (mako)
  # restent en Dracula via lib/theme — mismatch préexistant, hors périmètre
  # ici (voir la discussion à ce sujet).
  colorschemes.catppuccin = {
    enable = true;
    settings.flavour = "macchiato";
  };

  # ===========================================================================
  # Diagnostics (lua/plugins/lsp.lua)
  # ===========================================================================
  diagnostic.settings = {
    update_in_insert = true;
    severity_sort = true;
    virtual_text = false;
    virtual_lines.only_current_line = true;
    signs = true;
    underline = true;
    float.border = "rounded";
  };
}
