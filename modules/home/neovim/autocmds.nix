{
  autoCmd = [
    {
      event = [ "BufWinEnter" ];
      callback = {
        __raw = ''
          function()
              vim.cmd "set formatoptions-=cro"
          end
        '';
      };
    }
    {
      event = "FileType";
      pattern = [ "markdown" ];
      command = "setlocal conceallevel=2";
      desc = "Conceal Syntax Attribute";
    }
    {
      event = [ "FileType" ];
      pattern = [ "markdown" ];
      callback = {
        __raw = ''
          function()
            vim.cmd ":TSDisable highlight"
          end
        '';
      };
    }
    {
      event = [ "FileType" ];
      pattern = [ "nix" ];
      command = "TSContextDisable";
      desc = "Disable context for nix files as it's annoying";
    }
    {
      event = [ "FileType" ];
      pattern = [
        "netrw"
        "Jaq"
        "qf"
        "git"
        "help"
        "man"
        "lspinfo"
        "alpha"
        "lir"
        "DressingSelect"
        ""
      ];
      callback = {
        __raw = ''
          function()
            vim.cmd [[
              nnoremap <silent> <buffer> q :close<CR>
              set nobuflisted
            ]]
          end
        '';
      };
    }
    {
      event = [ "CmdWinEnter" ];
      callback = {
        __raw = ''
          function()
              vim.cmd "quit"
            end
        '';
      };
    }
    {
      event = [ "VimResized" ];
      callback = {
        __raw = ''
          function()
              vim.cmd "tabdo wincmd ="
          end
        '';
      };
    }
  ];
}
