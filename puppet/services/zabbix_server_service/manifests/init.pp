class zabbix_server_service (
  $listening_address,
  $database_address,
  $database_name,
  $database_user,
  $database_password,
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
