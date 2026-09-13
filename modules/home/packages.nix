{ pkgs, ... }:
{
  # Nix packages to install to $HOME
  #
  # Search for packages here: https://search.nixos.org/packages
  home.packages = with pkgs; [
    # Unix tools
    ripgrep # Better `grep`
    fd
    expat
    sd
    tree
    zip
    unzip
    gnupg
    tldr # TLDR for man

    # utils
    file
    dust # anciennement du-dust, renommé en 26.05
    duf

    # Nix dev
    cachix
    nil # Nix language server
    nix-info
    nixpkgs-fmt

    # On ubuntu, we need this less for `man home-configuration.nix`'s pager to
    # work.
    less

    # Tools
    pavucontrol
    networkmanagerapplet
    blueman
    yubikey-personalization
    #github-copilot-intellij-agent

    # Dev
    tmate
    docker
    # neovim est fourni par NixVim (voir modules/home/neovim/), on ne
    # veut pas d'un second binaire nvim "nu" en conflit dans le PATH.
    gcc
    sqlfluff
    git-review
    deno
    jdk21
    maven
    opentofu
    typst
    typst-live
    onlyoffice-desktopeditors
    packer
    vscode

    # Productivity
    brave
    flameshot
    thunar # anciennement xfce.thunar, déplacé au niveau racine (26.05)
    discord
    termius
  ];

  # add environment variables
  home.sessionVariables = {
    # clean up ~
    XAUTHORITY = "$XDG_RUNTIME_DIR/Xauthority";

    # enable scrolling in git diff
    DELTA_PAGER = "less -R";

    EDITOR = "nvim";
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
  };

  # Programs natively supported by home-manager.
  # They can be configured in `programs.*` instead of using home.packages.
  programs = {
    # Better `cat`
    bat.enable = true;
    # Type `<ctrl> + r` to fuzzy search your shell history
    fzf.enable = true;
    jq.enable = true;
    # Install btop https://github.com/aristocratos/btop
    btop.enable = true;
  };
}
