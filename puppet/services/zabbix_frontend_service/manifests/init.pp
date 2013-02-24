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

  service { "apache2":
    ensure => running,
    require => [
      Package[$packages],
      File["/etc/zabbix/dbconfig.php"],
    ],
  }

}
