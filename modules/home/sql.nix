{ 
    config,
    pkgs,
    lib,
    ...
}:

let
  initdb = pkgs.writeShellScript "initdb" ''
    if [ ! -d ${config.home.homeDirectory}/postgres_data ]; then
      ${pkgs.postgresql}/bin/initdb --locale "$LANG" -E UTF-8
    fi
  '';
in
{
  systemd.user.services.initdb = {
    Unit = { Description = "initdb"; };
    
    Service = {
      Type = "oneshot";
      Environment = "PGDATA=${config.home.homeDirectory}/postgres_data";
      ExecStart = "${initdb}";
      RemainAfterExit = "true";
    };
  };

  systemd.user.services.postgres = {
    Unit = {
      Description = "PostGraisseQL";
      Requires = "initdb.service";
      After = "initdb.service";
    };

    Service = {
      Type = "simple";
      Environment = "PGDATA=${config.home.homeDirectory}/postgres_data";
        ExecStart =
          "${pkgs.postgresql}/bin/postgres -k /tmp";
        Restart = "on-failure";
      };
    };

    home.sessionVariables = {
      PGHOST = "/tmp";
      PGDATA = "${config.home.homeDirectory}/postgres_data";
    };
}
