class zabbix_frontend_service (
    $zabbix_server_address,
    $zabbix_database_address,
    $zabbix_database_name,
    $zabbix_database_user,
    $zabbix_database_password,
) {

  $packages = [
    "apache2-mpm-prefork",
    "libapache2-mod-php5",
    "php5",
    "php5-pgsql",
    "zabbix-frontend-php",
  ]

  package { $packages:
    ensure => present,
  }

  file { "/etc/zabbix/dbconfig.php":
    content => template("zabbix_frontend_service/dbconfig.php.erb"),
    require => Package[$packages],
    notify  => Service["apache2"],
  }

  Augeas {
    require => Package[$packages],
    notify  => Service["apache2"],
  }

  augeas { "/files/etc/php5/apache2/php.ini/PHP/max_execution_time":
    context => "/files/etc/php5/apache2/php.ini/PHP",
    changes => "set max_execution_time 1200",
  }

  augeas { "/files/etc/php5/apache2/php.ini/PHP/post_max_size":
    context => "/files/etc/php5/apache2/php.ini/PHP",
    changes => "set post_max_size 50M",
  }

  augeas { "/files/etc/php5/apache2/php.ini/PHP/max_input_time":
    context => "/files/etc/php5/apache2/php.ini/PHP",
    changes => "set max_input_time 1200",
  }

  augeas { "/files/etc/php5/apache2/php.ini/Date/date.timezone":
    context => "/files/etc/php5/apache2/php.ini/Date",
    changes => "set date.timezone Europe/Warsaw",
  }

  service { "apache2":
    ensure => running,
    require => [
      Package[$packages],
      File["/etc/zabbix/dbconfig.php"],
    ],
  }

}
