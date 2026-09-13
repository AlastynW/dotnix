# Neovim, entièrement déclaratif via NixVim (voir ./nixvim.nix).
#
# Remplace l'ancien home.file.".config/nvim" qui symlinkait
# /home/alastyn/Nvim-Config (un clone git local, hors de Nix).
{
  flake,
  ...
}:
let
  inherit (flake) inputs;
in
{
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];

  # ./nixvim (dossier, voir son default.nix) est branché comme sous-module
  # (via `imports`, pas via un `import` Nix classique) pour être évalué DANS
  # le système de modules de NixVim : c'est ce qui lui donne accès à
  # lib.nixvim.mkRaw et consorts. Appelé depuis l'extérieur (import ./nixvim
  # { inherit pkgs lib; }), ce lib n'a pas l'extension nixvim -> "attribute
  # 'nixvim' missing".
  programs.nixvim = {
    enable = true;
    imports = [ ./nixvim ];
  };
}
