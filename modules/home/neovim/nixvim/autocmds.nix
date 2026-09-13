# ===========================================================================
# Autocommandes (core/autocmd.lua + bouts de core/settings.lua)
# ===========================================================================
{ lib, ... }:
let
  mkRaw = lib.nixvim.mkRaw;
in
{
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
}
