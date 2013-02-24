class zabbix::server {

  package { "zabbix-server-pgsql":
    ensure => present,
  }

}
