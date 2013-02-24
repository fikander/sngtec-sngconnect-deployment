class zabbix_server_service (
  $listening_address,
  $database_address,
  $database_name = "zabbix",
  $database_user = "zabbix",
  $database_password = "zabbix"
) {

  include zabbix::server

  postgresql::db { $database_name:
    user     => $database_user,
    password => $database_password,
    require  => Class["postgresql_service"],
    notify   => Exec["create_zabbix_database_schema"],
  }

  exec { "create_zabbix_database_schema":
    command     => "/usr/bin/psql -t -h ${database_address} -U ${database_user} -d ${database_name} -f /usr/share/zabbix-server/postgresql.sql",
    environment => "PGPASSWORD=${database_password}",
    user        => "postgres",
    require     => Postgresql::Db[$database_name],
    refreshonly => true,
    notify      => Exec["create_zabbix_initial_data"],
  }
  exec { "create_zabbix_initial_data":
    command     => "/usr/bin/psql -t -h ${database_address} -U ${database_user} -d ${database_name} -f /usr/share/zabbix-server/data.sql",
    environment => "PGPASSWORD=${database_password}",
    user        => "postgres",
    require     => Exec["create_zabbix_database_schema"],
    refreshonly => true,
  }
#  exec { "reassign_zabbix_tables_ownership":
#    command     => "/usr/bin/psql -t -d ${database_name} -c 'REASSIGN OWNED BY postgres TO ${database_user};'",
#    user        => "postgres",
#    require     => Exec["create_zabbix_initial_data"],
#    refreshonly => true,
#  }
#  postgresql_psql { "create_zabbix_database_schema":
#    command     => file("/usr/share/zabbix-server/postgresql.sql"),
#    db          => $database_name,
#    require     => Postgresql::Db[$database_name],
#    refreshonly => true,
#    notify      => Postgresql_psql["create_zabbix_initial_data"],
#  }
#
#  postgresql_psql { "create_zabbix_initial_data":
#    command     => file("/usr/share/zabbix-server/data.sql"),
#    db          => $database_name,
#    require     => Postgresql_psql["create_zabbix_database_schema"],
#    refreshonly => true,
#    notify      => Postgresql_psql["reassign_zabbix_tables_ownership"],
#  }
#
#  postgresql_psql { "reassign_zabbix_tables_ownership":
#    command     => "REASSIGN OWNED BY postgres TO ${database_user};",
#    db          => $database_name,
#    require     => Postgresql_psql["create_zabbix_initial_data"],
#    refreshonly => true,
#  }

  file { "/etc/zabbix/zabbix_server.conf":
    content => template("zabbix_server_service/zabbix_server.conf.erb"),
    require => Class["zabbix::server"],
    notify  => Service["zabbix-server"],
  }

  service { "zabbix-server":
    ensure  => running,
    require => [
      Class["zabbix::server"],
      File["/etc/zabbix/zabbix_server.conf"],
      Postgresql::Db[$database_name],
      Exec["create_zabbix_database_schema"],
      Exec["create_zabbix_initial_data"],
    ],
  }

}
