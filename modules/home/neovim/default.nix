{ 
    config,
    pkgs,
    lib,
    vimUtils,
    ...
}:
{
    programs.neovim = {
	enable = true;
        viAlias = true;
        vimAlias = true;
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
          rust-analyzer
        ];
    };
}
