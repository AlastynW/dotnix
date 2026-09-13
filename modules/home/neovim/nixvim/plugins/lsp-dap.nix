# ===========================================================================
# LSP, Rust et débogage (lua/plugins/lsp.lua, rust.lua, dap.lua)
# ===========================================================================
{ ... }:
{
  plugins = {
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
    dap.enable = true;
    # dap-ui/dap-virtual-text sont maintenant des modules plugins.* à part
    # entière (plugins.dap.extensions.* est renommé).
    dap-ui.enable = true;
    dap-virtual-text.enable = true;
  };
}
