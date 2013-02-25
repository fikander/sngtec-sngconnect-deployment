class zabbix_agent_service (
  $listening_addresses,
  $zabbix_server_address
) {

  include zabbix::agent

  file { "/etc/zabbix/zabbix_agentd.conf":
    content => template("zabbix_agent_service/zabbix_agentd.conf.erb"),
    require => Class["zabbix::agent"],
    notify  => Service["zabbix-agent"],
  }

  service { "zabbix-agent":
    ensure  => running,
    require => [
      Class["zabbix::agent"],
      File["/etc/zabbix/zabbix_agentd.conf"],
    ],
  }

}
