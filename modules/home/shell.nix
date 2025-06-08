{ pkgs, lib, ... }:
{
  programs = {
    # on macOS, you probably don't need this
    bash = {
      enable = true;
      initExtra = ''
        # Custom bash profile goes here
        export PGDATA="$HOME/postgres_data"
        export PGHOST="/tmp"
        alias clangf='find $(git rev-parse --show-toplevel) -name "*.h" -o -name "*.c" -o -name "*.hh" -o -name "*.cc" -o -name "*.cpp" -o -name "*.hxx" -o -name "*.cxx" -o -name "*.hpp"  | xargs clang-format -i'
      '';
    };

    # For macOS's default shell.
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      envExtra = ''
        # Custom zshrc goes here
      '';
    };

    # Type `z <pat>` to cd to some directory
    zoxide.enable = true;

    # Better shell prmot!
    starship = {
      enable = true;
      settings = {
        username = {
          style_user = "blue bold";
          style_root = "red bold";
          format = "[$user]($style) ";
          disabled = false;
          show_always = true;
        };
        hostname = {
          ssh_only = false;
          ssh_symbol = "🌐 ";
          format = "on [$hostname](bold red) ";
          trim_at = ".local";
          disabled = false;
        };
      };
    };
  };
}
