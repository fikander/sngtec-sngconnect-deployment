class monit_service {

  class { "monit":
    interval => 20,
    admin    => "admin@example.com",
  }

  if tagged("ssh_service") {
    monit::monitor { "ssh":
      pidfile => "/var/run/sshd.pid",
      ip_port => "22",
    }
  }

  if tagged("zabbix_agent_service") {
    monit::monitor { "zabbix-agent":
      pidfile => "/var/run/zabbix/zabbix_agentd.pid",
      checks  => [
        "if failed host ${zabbix_agent_service::listening_address} port 10050 type tcp then restart",
      ],
    }
  }

  if tagged("postgresql_service") {
    monit::monitor { "postgresql":
      pidfile => "/var/run/postgresql/9.1-main.pid",
      checks  => [
        "if failed host ${postgresql_service::listening_address} port 5432 type tcp then restart",
      ],
    }
  }

  if tagged("cassandra_service") {
    monit::monitor { "cassandra":
      pidfile => "/var/run/cassandra.pid",
      checks  => [
        "if failed host ${cassandra_service::listening_address} port 7000 type tcp then restart",
        "if failed host ${cassandra_service::listening_address} port 9160 type tcp then restart",
      ],
    }
  }

}
