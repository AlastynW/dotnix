# ===========================================================================
# Keymaps (core/keymaps.lua + tous les `keys = {...}` des specs lazy)
# ===========================================================================
{ lib, ... }:
let
  mkRaw = lib.nixvim.mkRaw;
in
{
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
}
