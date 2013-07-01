class firewall_service (
  $allow_external_cassandra_access = true,
  $allow_external_postgresql_access = true
) {

  include ufw

  if tagged('ssh_service') {
    ufw::allow { 'ssh':
      ip   => 'any',
      port => 22,
    }
  }

  if tagged('zabbix_agent_service') {
    ufw::allow { 'zabbix-agent':
      ip    => $zabbix_agent_service::listening_address,
      port  => 10050,
      proto => 'tcp'
    }
  }

  if tagged("zabbix_server_service") {
    ufw::allow { 'zabbix-server':
      ip    => $zabbix_server_service::listening_address,
      port  => 10051,
      proto => 'tcp',
    }
  }

  if tagged("zabbix_frontend_service") {
    ufw::allow { 'zabbix-frontend':
      ip    => 'any',
      port  => 80,
      proto => 'tcp',
    }
  }

  if tagged("nginx_service") {
    ufw::allow { 'nginx':
      ip    => 'any',
      port  => 80,
      proto => 'tcp',
    }
  }

  if $allow_external_cassandra_access {
    if tagged("cassandra_service") {
      ufw::allow { 'cassandra-internode':
        ip    => $cassandra_service::listening_address,
        port  => 7000,
        proto => 'tcp',
      }
      ufw::allow { 'cassandra-client':
        ip    => $cassandra_service::listening_address,
        port  => 9160,
        proto => 'tcp',
      }
    }
  }

  if $allow_external_postgresql_access {
    if tagged("postgresql_service") {
      ufw::allow { 'postgresql':
        ip    => $postgresql_service::listening_address,
        port  => 5432,
        proto => 'tcp',
      }
    }
  }

}
