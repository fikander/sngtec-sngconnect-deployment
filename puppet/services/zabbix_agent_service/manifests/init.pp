class zabbix_agent_service (
  $listening_address,
  $zabbix_server_address
) {

  package { "zabbix-agent":
    ensure => present,
  }

  file { "/etc/zabbix":
    ensure => directory,
  }
  file { "/etc/zabbix/zabbix_agentd.conf":
    content => template("zabbix_agent_service/zabbix_agentd.conf.erb"),
    require => [
      Package["zabbix-agent"],
      File["/etc/zabbix"],
    ],
    notify  => Service["zabbix-agent"],
  }

  service { "zabbix-agent":
    ensure  => running,
    require => Package["zabbix-agent"],
  }

}
