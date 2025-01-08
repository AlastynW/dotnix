{ 
    config,
    pkgs,
    lib,
    vimUtils,
    ...
}:
{
    home.file.".config/nvim" = {
  	enable = true;
  	recursive = true;
  	source = /home/alastyn/Nvim-Config;
    };
}
