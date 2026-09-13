# ===========================================================================
# Git et TODOs (lua/plugins/dev.lua)
# ===========================================================================
{ ... }:
{
  plugins = {
    todo-comments = {
      enable = true;
      settings = {
        keywords = {
          FIX = {
            icon = " ";
            color = "error";
            alt = [
              "FIXME"
              "BUG"
              "FIXIT"
              "ISSUE"
            ];
          };
          TODO = {
            icon = " ";
            color = "info";
          };
          HACK = {
            icon = " ";
            color = "warning";
          };
          WARN = {
            icon = " ";
            color = "warning";
            alt = [
              "WARNING"
              "XXX"
            ];
          };
          PERF = {
            icon = " ";
            alt = [
              "OPTIM"
              "PERFORMANCE"
              "OPTIMIZE"
            ];
          };
          NOTE = {
            icon = " ";
            color = "hint";
            alt = [ "INFO" ];
          };
          BONUS = {
            icon = " ";
            color = "#D3D3D3";
            alt = [ "BONUS" ];
          };
          TEST = {
            icon = "⏲ ";
            color = "test";
            alt = [
              "TESTING"
              "PASSED"
              "FAILED"
            ];
          };
        };
        colors = {
          error = [
            "DiagnosticError"
            "ErrorMsg"
            "#DC2626"
          ];
          warning = [
            "DiagnosticWarn"
            "WarningMsg"
            "#FBBF24"
          ];
          info = [
            "DiagnosticInfo"
            "#2563EB"
          ];
          hint = [
            "DiagnosticHint"
            "#10B981"
          ];
          default = [
            "Identifier"
            "#7C3AED"
          ];
          test = [
            "Identifier"
            "#FF00FF"
          ];
        };
      };
    };

    trouble.enable = true;

    neogit = {
      enable = true;
      settings = { };
    };

    diffview.enable = true;
  };
}
