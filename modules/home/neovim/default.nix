{ config, pkgs, lib, vimUtils, ... }:

{
  programs.neovim = {
    extraConfig = builtins.concatStringsSep "\n" [
      ''
        lua << EOF
        ${lib.strings.fileContents ./lua/core/autocmd.lua}
        ${lib.strings.fileContents ./lua/core/settings.lua}
        ${lib.strings.fileContents ./lua/core/keymaps.lua}
        ${lib.strings.fileContents ./lua/lazy-config.lua}
        ${lib.strings.fileContents ./lua/plugins/dev.lua}
        ${lib.strings.fileContents ./lua/plugins/telescope.lua}
        ${lib.strings.fileContents ./lua/plugins/treesitter.lua}
        ${lib.strings.fileContents ./lua/plugins/bufferline.lua}
        ${lib.strings.fileContents ./lua/plugins/dap.lua}
        ${lib.strings.fileContents ./lua/plugins/colorscheme.lua}
        ${lib.strings.fileContents ./lua/plugins/completions.lua}
        ${lib.strings.fileContents ./lua/plugins/lsp.lua}
        ${lib.strings.fileContents ./lua/plugins/markdown.lua}
        EOF
      ''
    ];

    extraPackages = with pkgs; [
      xclip

      tree-sitter
      jq
      curl

      telescope
      bat
      ripgrep
      fd

      zathura
      xdotool

      # extra language servers
      #rnix-lsp TODO fix slow closing time of neovim
      nodePackages.typescript
      nodePackages.typescript-language-server
      gopls
      texlab
      nodePackages.pyright
      rust-analyzer
    ];

    plugins = with pkgs.vimPlugins; [
      # UI
      nvim-colorizer-lua
      nvim-web-devicons
      lsp-colors-nvim
      trouble-nvim
      lspsaga-nvim
      todo-comments-nvim
      lualine-nvim

      # Navigation
      nvim-treesitter
      nvim-treesitter.withAllGrammars
      telescope-nvim
      which-key-nvim
      vim-eunuch

      # Git
      gitsigns-nvim
      vim-fugitive
      # vim-gitgutter

      # LSP
      nvim-lspconfig
      nvim-jdtls

      # DAP
      nvim-dap
      nvim-dap-ui
      nvim-dap-virtual-text
      telescope-dap-nvim

      # Theme
      nightfox-nvim
      tokyonight-nvim
      tender-vim

      # Completion
      nvim-cmp
      cmp-nvim-lsp
      cmp-nvim-lua
      cmp-nvim-lsp-signature-help
      cmp-path
      cmp-buffer
      cmp_luasnip
      cmp-cmdline

      # Tests
      nvim-test
      plenary-nvim
      neotest-plenary
      FixCursorHold-nvim
      neotest
      neotest-dotnet
      neotest-rust

      # Others
      mason-nvim
      mason-lspconfig-nvim
      toggleterm-nvim
      markdown-preview-nvim
      # glow-nvim
      # ultisnips
      luasnip
      vimtex
      neoformat
      vim-addon-nix
      vim-toml
      # vim-clang-format
    ];

  };
}
