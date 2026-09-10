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

  Omissions volontaires (voir commentaires en bas de fichier) :
    - peek.nvim (preview markdown) : nécessite un build via deno, non
      trivialement déclaratif -> proposition alternative en commentaire.
    - Le "chrome" LazyVim par défaut (which-key, flash, mini.icons, la
      dashboard de démarrage, etc.) n'est pas reconstruit à l'identique.
*/
{
  pkgs,
  lib,
  ...
}:
let
  mkRaw = lib.nixvim.mkRaw;
in
{
  # ===========================================================================
  # Options globales (core/settings.lua)
  # ===========================================================================
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

  # vim.filetype.add({...}) — pas d'option déclarative dédiée, extraConfigLua.
  extraConfigLua = ''
    vim.filetype.add({
      extension = {
        mdx = "markdown",
        vhd = "vhdl",
        vhdl = "vhdl",
        cu = "c",
      },
    })
  '';

  # ===========================================================================
  # Autocommandes (core/autocmd.lua + bouts de core/settings.lua)
  # ===========================================================================
  autoCmd = [
    {
      event = "FileType";
      pattern = "rust";
      callback = mkRaw ''
        function()
          vim.opt_local.spell = false
        end
      '';
    }
    {
      event = "CursorHold";
      callback = mkRaw ''
        function()
          local diagnostics = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
          if #diagnostics > 0 then
            vim.diagnostic.open_float(nil, { focus = false })
          end
        end
      '';
    }
    {
      event = "FileType";
      pattern = "*";
      callback = mkRaw ''
        function()
          vim.opt.tabstop = 4
          vim.opt.shiftwidth = 4
          vim.opt.expandtab = true
        end
      '';
    }
    {
      event = "FileType";
      pattern = [
        "lua"
        "rust"
      ];
      callback = mkRaw ''
        function()
          vim.bo.tabstop = 4
          vim.bo.shiftwidth = 4
        end
      '';
    }
    {
      event = "FileType";
      pattern = "ada";
      callback = mkRaw ''
        function()
          vim.bo.tabstop = 4
          vim.bo.shiftwidth = 4
          vim.bo.expandtab = true
        end
      '';
    }
    {
      event = "FileType";
      pattern = "make";
      callback = mkRaw ''
        function()
          vim.bo.tabstop = 4
          vim.bo.shiftwidth = 4
          vim.bo.expandtab = false
        end
      '';
    }
    {
      event = "FileType";
      pattern = [
        "yaml"
        "yml"
      ];
      callback = mkRaw ''
        function()
          vim.opt_local.tabstop = 2
          vim.opt_local.shiftwidth = 2
          vim.opt_local.expandtab = true
          vim.opt_local.autoindent = true
        end
      '';
    }
    {
      event = "LspAttach";
      callback = mkRaw ''
        function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.server_capabilities.documentFormattingProvider then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = args.buf })
              end,
            })
          end
        end
      '';
    }
  ];

  # ===========================================================================
  # Keymaps (core/keymaps.lua + tous les `keys = {...}` des specs lazy)
  # ===========================================================================
  keymaps = [
    # -- Telescope (core/keymaps.lua) --
    {
      mode = "n";
      key = "<A-o>";
      action = "<cmd>Telescope find_files<cr>";
      options.silent = true;
    }
    {
      mode = "n";
      key = "<A-d>";
      action = "<cmd>Telescope oldfiles<cr>";
    }
    {
      mode = "n";
      key = "<A-f>";
      action = "<cmd>Telescope live_grep<cr>";
    }
    {
      # ATTENTION : ceci écrase la commande native `m` (poser une marque),
      # tel quel dans le dépôt d'origine.
      mode = "n";
      key = "m";
      action = "<cmd>Telescope man_pages<cr>";
    }

    # -- TODO --
    {
      mode = "n";
      key = "ft";
      action = ":TodoTelescope <cr>";
    }
    {
      mode = "n";
      key = "tt";
      action = "i// TODO: <ESC>";
    }

    # -- ; -> : --
    {
      mode = "n";
      key = ";";
      action = ":";
    }

    # -- Onglets --
    {
      mode = "n";
      key = "<A-1>";
      action = "1gt";
    }
    {
      mode = "n";
      key = "<A-2>";
      action = "2gt";
    }
    {
      mode = "n";
      key = "<A-3>";
      action = "3gt";
    }
    {
      mode = "n";
      key = "<A-4>";
      action = "4gt";
    }
    {
      mode = "n";
      key = "<A-5>";
      action = "5gt";
    }
    {
      mode = "n";
      key = "<A-6>";
      action = "6gt";
    }
    {
      mode = "n";
      key = "<A-7>";
      action = "7gt";
    }
    {
      mode = "n";
      key = "<A-8>";
      action = "8gt";
    }
    {
      mode = "n";
      key = "<A-9>";
      action = "9gt";
    }
    {
      mode = "n";
      key = "<A-t>";
      action = ":tabnew<CR>";
    }
    {
      mode = "n";
      key = "<A-w>";
      action = ":bdelete<CR>";
    }
    {
      mode = "n";
      key = "<A-h>";
      action = ":tabprevious<CR>";
    }
    {
      mode = "n";
      key = "<A-l>";
      action = ":tabnext<CR>";
    }

    # -- DAP --
    {
      mode = "n";
      key = "<F5>";
      action = mkRaw "function() require('dap').continue() end";
      options.silent = true;
    }
    {
      mode = "n";
      key = "<F10>";
      action = mkRaw "function() require('dap').step_over() end";
      options.silent = true;
    }
    {
      mode = "n";
      key = "<F11>";
      action = mkRaw "function() require('dap').step_into() end";
      options.silent = true;
    }
    {
      mode = "n";
      key = "<F12>";
      action = mkRaw "function() require('dap').step_out() end";
      options.silent = true;
    }
    {
      mode = "n";
      key = "<Leader>b";
      action = mkRaw "function() require('dap').toggle_breakpoint() end";
      options.silent = true;
    }

    # -- LSP (lua/plugins/lsp.lua : on_attach) --
    {
      mode = "n";
      key = "<C-k>";
      action = mkRaw "vim.diagnostic.goto_prev";
      options.desc = "Prev Diagnostic";
    }
    {
      mode = "n";
      key = "<C-j>";
      action = mkRaw "vim.diagnostic.goto_next";
      options.desc = "Next Diagnostic";
    }
    {
      mode = "n";
      key = "<C-,>";
      action = mkRaw "vim.diagnostic.open_float";
      options.desc = "Float Diagnostic";
    }
    {
      mode = "n";
      key = "gd";
      action = mkRaw "vim.lsp.buf.definition";
      options.desc = "Goto Definition";
    }
    {
      mode = "n";
      key = "gD";
      action = mkRaw "vim.lsp.buf.declaration";
      options.desc = "Goto Declaration";
    }
    {
      mode = "n";
      key = "gr";
      action = mkRaw "vim.lsp.buf.references";
      options.desc = "Goto References";
    }
    {
      mode = "n";
      key = "gi";
      action = mkRaw "vim.lsp.buf.implementation";
      options.desc = "Goto Implementation";
    }
    {
      mode = "n";
      key = "gt";
      action = mkRaw "vim.lsp.buf.type_definition";
      options.desc = "Goto Type Definition";
    }
    {
      mode = "n";
      key = "K";
      action = mkRaw "vim.lsp.buf.hover";
      options.desc = "Hover";
    }
    {
      mode = "n";
      key = "<A-k>";
      action = mkRaw "vim.lsp.buf.signature_help";
      options.desc = "Signature Help";
    }
    {
      mode = "n";
      key = "<A-r>";
      action = mkRaw "vim.lsp.buf.rename";
      options.desc = "Rename";
    }
    {
      mode = [
        "n"
        "i"
      ];
      key = "<A-CR>";
      action = mkRaw ''
        function()
          vim.lsp.buf.code_action({
            apply = true,
            context = {
              only = { "quickfix", "refactor", "source" },
              diagnostics = vim.lsp.diagnostic.get_line_diagnostics(),
            },
            border = "rounded",
          })
        end
      '';
      options.desc = "Code Action";
    }
    {
      mode = "n";
      key = "<space><space>";
      action = mkRaw "function() vim.lsp.buf.format({ async = true }) end";
      options.desc = "Format";
    }

    # -- nvim-tree --
    {
      mode = "n";
      key = "<C-e>";
      action = "<cmd>NvimTreeToggle<CR>";
      options.desc = "Toggle file explorer";
    }
    {
      mode = "n";
      key = "<leader>td";
      action = "<cmd>bdelete<CR>";
      options.desc = "Delete Current Buffer";
    }

    # -- notify / noice --
    {
      mode = "n";
      key = "<leader>un";
      action = mkRaw "function() require('notify').dismiss({ silent = true, pending = true }) end";
      options.desc = "Dismiss All Notifications";
    }
    {
      mode = "n";
      key = "<leader>D";
      action = mkRaw "function() require('notify').dismiss() end";
      options.desc = "Dismiss notification";
    }

    # -- dev.lua : todo-comments / trouble / neogit --
    {
      mode = "n";
      key = "<leader>ft";
      action = "<cmd>TodoTelescope<cr>";
      options.desc = "Find Todo's";
    }
    {
      mode = "n";
      key = "<leader>gtr";
      action = "<cmd>Trouble diagnostics toggle<cr>";
      options.desc = "Find Diagnostics";
    }
    {
      mode = "n";
      key = "<leader>gtd";
      action = "<cmd>TodoQuickFix<cr>";
      options.desc = "Find Todo's";
    }
    {
      mode = "n";
      key = "<leader>gc";
      action = mkRaw "function() require('neogit').open({ kind = 'split' }) end";
      options.desc = "Neogit";
    }

    # -- rust.lua --
    {
      mode = "n";
      key = "<leader>rc";
      action = "<cmd>TermExec cmd='cargo check'<CR>";
      options.desc = "Cargo Check";
    }
    {
      mode = "n";
      key = "<leader>rb";
      action = "<cmd>TermExec cmd='cargo build'<CR>";
      options.desc = "Cargo Build";
    }
    {
      mode = "n";
      key = "<leader>rt";
      action = "<cmd>TermExec cmd='cargo test'<CR>";
      options.desc = "Cargo Test";
    }
    {
      mode = "n";
      key = "<leader>rr";
      action = "<cmd>TermExec cmd='cargo run --features 2d, dev'<CR>";
      options.desc = "Cargo Run";
    }

    # -- telescope.lua --
    {
      mode = "n";
      key = "<leader>ff";
      action = "<cmd>Telescope oldfiles<cr>";
      options.desc = "Find File";
    }
    {
      mode = "n";
      key = "<leader>fo";
      action = ''<cmd>Telescope find_files search_dirs={"./"}<cr>'';
      options.desc = "Open Recent File";
    }
    {
      mode = "n";
      key = "<leader>fb";
      action = "<cmd>Telescope buffers<cr>";
      options.desc = "Switch Buffer";
    }
    {
      mode = "n";
      key = "<leader>fg";
      action = "<cmd>Telescope live_grep<cr>";
      options.desc = "Find Text in Workspace";
    }
    {
      mode = "n";
      key = "<leader>fr";
      action = "<cmd>Telescope resume<cr>";
      options.desc = "Resume Last Search";
    }
    {
      mode = "n";
      key = "<leader>gb";
      action = "<cmd>Telescope git_branches<cr>";
      options.desc = "Branches";
    }
    {
      mode = "n";
      key = "<leader>gs";
      action = "<cmd>Telescope git_status<cr>";
      options.desc = "Status";
    }
    {
      mode = "n";
      key = "<leader>cs";
      action = "<cmd>Telescope colorscheme<cr>";
      options.desc = "Colorscheme";
    }
    {
      mode = "n";
      key = "<leader>tl";
      action = "<cmd>Telescope buffers<cr>";
      options.desc = "List Active Buffers";
    }
    {
      mode = "n";
      key = "<leader><F1>";
      action = ''<cmd>Telescope man_pages sections={"ALL"}<cr>'';
      options.desc = "Man Pages";
    }
    {
      mode = "n";
      key = "<leader>?";
      action = "<cmd>Telescope help_tags<cr>";
      options.desc = "Vim docs";
    }
    {
      mode = "n";
      key = "<leader>ls";
      action = "<cmd>Telescope lsp_document_symbols<cr>";
      options.desc = "Document Symbols";
    }
  ];

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
  # Plugins
  # ===========================================================================
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
      filters = {
        dotfiles = false;
        gitClean = false;
        noBuffer = false;
        custom = [
          "node_modules"
          "^.git$"
          "dist"
        ];
      };
      onAttach = mkRaw ''
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

    # -- lua/plugins/blink.lua --
    blink-cmp = {
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

    # -- lua/plugins/lsp.lua : serveurs LSP gérés nativement par Nix --
    lsp = {
      enable = true;
      servers = {
        bashls.enable = true;
        clangd.enable = true;
        cmake.enable = true;
        lua_ls.enable = true;
        pyright.enable = true;
      };
    };

    # -- lua/plugins/rust.lua --
    rustaceanvim = {
      enable = true;
      settings = {
        server = {
          default_settings = {
            "rust-analyzer" = {
              cargo.allFeatures = true;
              check.command = "clippy";
              procMacro.enable = true;
            };
          };
        };
      };
    };

    # -- lua/plugins/dap.lua --
    dap = {
      enable = true;
      extensions = {
        dap-ui.enable = true;
        dap-virtual-text.enable = true;
      };
    };

    # -- lua/plugins/dev.lua --
    todo-comments = {
      enable = true;
      settings = {
        keywords = {
          FIX = {
            icon = " ";
            color = "error";
            alt = [
              "FIXME"
              "BUG"
              "FIXIT"
              "ISSUE"
            ];
          };
          TODO = {
            icon = " ";
            color = "info";
          };
          HACK = {
            icon = " ";
            color = "warning";
          };
          WARN = {
            icon = " ";
            color = "warning";
            alt = [
              "WARNING"
              "XXX"
            ];
          };
          PERF = {
            icon = " ";
            alt = [
              "OPTIM"
              "PERFORMANCE"
              "OPTIMIZE"
            ];
          };
          NOTE = {
            icon = " ";
            color = "hint";
            alt = [ "INFO" ];
          };
          BONUS = {
            icon = " ";
            color = "#D3D3D3";
            alt = [ "BONUS" ];
          };
          TEST = {
            icon = "⏲ ";
            color = "test";
            alt = [
              "TESTING"
              "PASSED"
              "FAILED"
            ];
          };
        };
        colors = {
          error = [
            "DiagnosticError"
            "ErrorMsg"
            "#DC2626"
          ];
          warning = [
            "DiagnosticWarn"
            "WarningMsg"
            "#FBBF24"
          ];
          info = [
            "DiagnosticInfo"
            "#2563EB"
          ];
          hint = [
            "DiagnosticHint"
            "#10B981"
          ];
          default = [
            "Identifier"
            "#7C3AED"
          ];
          test = [
            "Identifier"
            "#FF00FF"
          ];
        };
      };
    };

    trouble.enable = true;

    neogit = {
      enable = true;
      settings = { };
    };

    diffview.enable = true;

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

  # ===========================================================================
  # Plugins hors périmètre NixVim : ajoutés bruts via extraPlugins.
  # ===========================================================================
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      pname = "typst-preview-nvim";
      version = "unstable";
      src = pkgs.fetchFromGitHub {
        owner = "chomosuke";
        repo = "typst-preview.nvim";
        rev = "main"; # épingler un commit précis en prod
        hash = lib.fakeHash; # `nix build` donnera le vrai hash à coller ici
      };
    })
    (pkgs.vimUtils.buildVimPlugin {
      pname = "hept-vim";
      version = "unstable";
      src = pkgs.fetchFromGitHub {
        owner = "Fymyte";
        repo = "hept.vim";
        rev = "main"; # idem
        hash = lib.fakeHash;
      };
    })
    # peek.nvim (preview markdown) nécessite `deno task build:fast` au build.
    # C'est faisable avec buildVimPlugin + nativeBuildInputs=[pkgs.deno], mais
    # volontairement omis ici pour garder un premier `nixos-rebuild` fiable.
    # Alternative plus simple à déclarer : pkgs.vimPlugins.markdown-preview-nvim.
  ];

  extraConfigLua = ''
    -- typst-preview.nvim (lazy=false, opts={})
    require("typst-preview").setup({})
  '';
}