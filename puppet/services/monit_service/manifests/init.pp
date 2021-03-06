class monit_service {

  class { "monit":
    interval => 20,
    admin    => "admin@example.com",
  }

  if tagged("ntp") {
    monit::monitor { "ntp":
      pidfile => "/var/run/ntpd.pid",
    }
    Class["ntp"] -> Class["monit_service"]
  }

  if tagged("ssh_service") {
    monit::monitor { "ssh":
      pidfile => "/var/run/sshd.pid",
      ip_port => "22",
    }
    Class["ssh_service"] -> Class["monit_service"]
  }

  if tagged("zabbix_agent_service") {
    monit::monitor { "zabbix-agent":
      pidfile => "/var/run/zabbix/zabbix_agentd.pid",
    }
    Class["zabbix_agent_service"] -> Class["monit_service"]
  }

  if tagged("zabbix_server_service") {
    monit::monitor { "zabbix-server":
      pidfile => "/var/run/zabbix/zabbix_server.pid",
      checks  => [
        "if failed host ${zabbix_server_service::listening_address} port 10051 type tcp then restart",
      ],
    }
    Class["zabbix_server_service"] -> Class["monit_service"]
  }

  if tagged("postgresql_service") {
    monit::monitor { "postgresql":
      pidfile => "/var/run/postgresql/9.1-main.pid",
      checks  => [
        "if failed host ${postgresql_service::listening_address} port 5432 type tcp then restart",
      ],
    }
    Class["postgresql_service"] -> Class["monit_service"]
  }

  if tagged("cassandra_service") {
    monit::monitor { "cassandra":
      pidfile => "/var/run/cassandra.pid",
      checks  => [
        "if failed host ${cassandra_service::listening_address} port 7000 type tcp then restart",
        "if failed host ${cassandra_service::listening_address} port 9160 type tcp then restart",
      ],
    }
    Class["cassandra_service"] -> Class["monit_service"]
  }

  if tagged("nginx_service") {
    monit::monitor { "nginx":
      pidfile => "/var/run/nginx.pid",
      checks  => [
        "if failed host 127.0.0.1 port 80 type tcp then restart",
      ],
    }
    Class["nginx_service"] -> Class["monit_service"]
  }

  if tagged("smtp_service") {
    monit::monitor { "exim":
      pidfile => "/var/run/exim4/exim.pid",
      checks  => [
        "if failed port 25 protocol smtp then restart",
      ],
    }
    Class["smtp_service"] -> Class["monit_service"]
  }

}
