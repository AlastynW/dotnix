{ 
    config,
    pkgs,
    lib,
    ...
}:

{
  systemd.user.services.initdb = {
    Unit = { Description = "initdb"; };
    
    Service = {
      Type = "oneshot";
      Environment = "PGDATA=${config.home.homeDirectory}/postgres_data";
      ExecStart =
        ''/run/current-system/sw/bin/initdb --locale "$LANG" -E UTF-8'';
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
          "/run/current-system/sw/bin/postgres -k /tmp";
        Restart = "on-failure";
      };
    };

    home.sessionVariables = {
      PGHOST = "/tmp";
      PGDATA=${config.home.homeDirectory}/postgres_data;
    };
}
