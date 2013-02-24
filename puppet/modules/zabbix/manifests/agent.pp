class zabbix::agent {

  package { "zabbix-agent":
    ensure => present,
  }

}
