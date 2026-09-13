# ===========================================================================
# Complétion (lua/plugins/blink.lua)
# ===========================================================================
{ ... }:
{
  plugins.blink-cmp = {
    enable = true;
    settings = {
      keymap = {
        "<Tab>" = [
          "select_next"
          "fallback"
        ];
        "<S-Tab>" = [
          "select_prev"
          "fallback"
        ];
        "<CR>" = [
          "accept"
          "fallback"
        ];
      };

      completion = {
        trigger.prefetch_on_insert = true;
        list.selection = {
          preselect = true;
          auto_insert = true;
        };
        documentation = {
          auto_show = true;
          auto_show_delay_ms = 100;
        };
        ghost_text.enabled = true;
      };

      appearance.nerd_font_variant = "mono";

      sources = {
        default = [
          "lsp"
          "path"
          "snippets"
          "buffer"
        ];
        providers.lsp = {
          fallbacks = [ ];
          score_offset = 0;
        };
      };
    };
  };
}
