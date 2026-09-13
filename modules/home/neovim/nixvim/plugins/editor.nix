# ===========================================================================
# Plugins d'édition : treesitter, telescope, nvim-tree, bufferline, toggleterm
# ===========================================================================
{ lib, ... }:
let
  mkRaw = lib.nixvim.mkRaw;
in
{
  plugins = {
    web-devicons.enable = true; # dépendance de nvim-tree/bufferline/telescope/trouble/diffview

    # -- lua/plugins/treesitter.lua --
    treesitter = {
      enable = true;
      settings = {
        highlight.enable = true;
        indent.enable = true;
      };
      # Installation des grammaires gérée par Nix plutôt que par :TSUpdate.
      nixGrammars = true;
    };

    # -- lua/plugins/telescope.lua --
    telescope = {
      enable = true;
      settings = {
        defaults = {
          prompt_prefix = " ";
          selection_caret = "➜ ";
          color_devicons = true;

          layout_config = {
            horizontal = {
              prompt_position = "bottom";
              preview_width = 0.55;
              results_width = 0.8;
            };
            vertical.mirror = false;
            width = 0.87;
            height = 0.80;
            preview_cutoff = 120;
          };

          initial_mode = "insert";
          borderchars = [
            "─"
            " "
            "─"
            " "
            "╭"
            "╮"
            "╯"
            "╰"
          ];
          file_ignore_patterns = [
            "%.d"
            "build/"
            "%.git/"
            "node%-modules/"
            "%.lock"
            "%.elf"
            "%.jpeg"
            "%.o"
            "%.png"
            "gnatprove/"
            "%.zip"
            "%.file"
            "%.pyc"
            "%.pdom"
            "%.list"
            "%.map"
            "%.vcd"
            ".DS_Store"
            "%.pdf"
            "%.xlsx"
            "%.jpg"
            "%.epci"
            "debug/"
            "monitoring/"
            "static/"
            "target/"
          ];

          vimgrep_arguments = [
            "rg"
            "-L"
            "--no-heading"
            "--with-filename"
            "--line-number"
            "--column"
            "--smart-case"
          ];

          mappings = {
            i = {
              "<C-n>" = mkRaw "require('telescope.actions').cycle_history_next";
              "<C-p>" = mkRaw "require('telescope.actions').cycle_history_prev";
              "<C-s>" = mkRaw "require('telescope.actions').select_horizontal";
              "<C-v>" = mkRaw "require('telescope.actions').select_vertical";
              "<C-t>" = mkRaw "require('telescope.actions').select_tab";
              "<Tab>" = mkRaw ''
                require('telescope.actions').toggle_selection
                  + require('telescope.actions').move_selection_worse
              '';
              "<S-Tab>" = mkRaw ''
                require('telescope.actions').toggle_selection
                  + require('telescope.actions').move_selection_better
              '';
              "<C-q>" = mkRaw ''
                require('telescope.actions').send_to_qflist
                  + require('telescope.actions').open_qflist
              '';
              "<M-q>" = mkRaw ''
                require('telescope.actions').send_selected_to_qflist
                  + require('telescope.actions').open_qflist
              '';
              "<C-l>" = mkRaw "require('telescope.actions').complete_tag";
            };
            n = {
              "<Esc>" = mkRaw "require('telescope.actions').close";
              "?" = mkRaw "require('telescope.actions').which_key";
            };
          };
        };
      };
    };

    # -- lua/plugins/init.lua : nvim-tree --
    nvim-tree = {
      enable = true;
      # filters.* et onAttach vivent maintenant sous settings.* (le module
      # nixvim mappe désormais 1:1 sur les clés lua de nvim-tree.setup()).
      settings = {
        filters = {
          dotfiles = false;
          git_clean = false;
          no_buffer = false;
          custom = [
            "node_modules"
            "^.git$"
            "dist"
          ];
        };
        on_attach = mkRaw ''
          function(bufnr)
            local api = require("nvim-tree.api")
            api.config.mappings.default_on_attach(bufnr)
            vim.keymap.set("n", "<C-e>", api.tree.close, {
              buffer = bufnr,
              noremap = true,
              silent = true,
              desc = "Close NvimTree",
            })
          end
        '';
      };
    };

    # -- lua/plugins/bufferline.lua --
    bufferline = {
      enable = true;
      settings = {
        options = {
          close_command = "Bdelete! %d";
          right_mouse_command = "Bdelete! %d";
          left_mouse_command = "buffer %d";
          max_name_length = 14;
          max_prefix_length = 13;
          tab_size = 20;
          show_buffer_close_icons = true;
          show_buffer_icons = true;
          show_tab_indicators = true;
          diagnostics = "nvim_lsp";
          always_show_bufferline = true;
          separator_style = "thin";

          offsets = [
            {
              filetype = "NvimTree";
              text = "File Explorer";
              text_align = "center";
              padding = 1;
            }
            {
              filetype = "undotree";
              text = "Undo Tree";
              text_align = "center";
              highlight = "Directory";
              separator = true;
            }
          ];

          diagnostics_indicator = mkRaw ''
            function(count, level, diagnostics_dict, context)
              local s = " "
              for e, n in pairs(diagnostics_dict) do
                local sym = e == "error" and " " or (e == "warning" and " " or "")
                if sym ~= "" then
                  s = n .. sym .. s
                end
              end
              return s
            end
          '';
        };
      };
    };

    # -- lua/plugins/term.lua --
    toggleterm = {
      enable = true;
      settings = {
        open_mapping = mkRaw "[[<C-Enter>]]";
        size = mkRaw ''
          function(term)
            if term.direction == "horizontal" then
              return 15
            elseif term.direction == "vertical" then
              return vim.o.columns * 0.4
            end
            return 20
          end
        '';
        direction = "float";
        insert_mappings = true;
        shell = mkRaw "vim.o.shell";
        terminal_mappings = true;
        close_on_exit = false;
      };
    };
  };
}
