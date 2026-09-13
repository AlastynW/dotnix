# ===========================================================================
# UI : notifications, command-line, markdown (lua/plugins/init.lua, markdown.lua)
# ===========================================================================
{ lib, ... }:
let
  mkRaw = lib.nixvim.mkRaw;
in
{
  plugins = {
    # -- lua/plugins/init.lua : notify / noice --
    notify = {
      enable = true;
      settings = {
        timeout = 1500;
        render = "minimal";
        stages = "slide";
        max_height = mkRaw "function() return math.floor(vim.o.lines * 0.75) end";
        max_width = mkRaw "function() return math.floor(vim.o.columns * 0.75) end";
        on_open = mkRaw ''
          function(win)
            vim.api.nvim_win_set_config(win, { zindex = 100 })
          end
        '';
      };
    };

    noice = {
      enable = true;
      settings = {
        lsp.override = {
          "vim.lsp.util.convert_input_to_markdown_lines" = true;
          "vim.lsp.util.stylize_markdown" = true;
          "cmp.entry.get_documentation" = true;
        };
        cmdline.view = "cmdline";
        presets = {
          bottom_search = true;
          command_palette = true;
          long_message_to_split = true;
          inc_rename = false;
          lsp_doc_border = false;
        };
        routes = [
          {
            filter = {
              event = "msg_show";
              kind = "";
              find = "written";
            };
            opts.skip = true;
          }
        ];
      };
    };

    # -- lua/plugins/markdown.lua --
    render-markdown = {
      enable = true;
      settings = {
        code = {
          sign = true;
          width = "block";
          right_pad = 1;
        };
        heading = {
          enabled = true;
          sign = true;
          position = "overlay";
          icons = [
            "󰲡 "
            "󰲣 "
            "󰲥 "
            "󰲧 "
            "󰲩 "
            "󰲫 "
          ];
          signs = [ "󰫎 " ];
          width = "full";
          left_margin = 0;
          left_pad = 0;
          right_pad = 0;
          min_width = 0;
          border = true;
          border_virtual = false;
          border_prefix = false;
          above = "▄";
          below = "▀";
          backgrounds = [
            "RenderMarkdownH1Bg"
            "RenderMarkdownH2Bg"
            "RenderMarkdownH3Bg"
            "RenderMarkdownH4Bg"
            "RenderMarkdownH5Bg"
            "RenderMarkdownH6Bg"
          ];
          foregrounds = [
            "RenderMarkdownH1"
            "RenderMarkdownH2"
            "RenderMarkdownH3"
            "RenderMarkdownH4"
            "RenderMarkdownH5"
            "RenderMarkdownH6"
          ];
        };
      };
    };
  };
}
