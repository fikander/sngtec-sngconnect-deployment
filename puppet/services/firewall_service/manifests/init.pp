class firewall_service (
  $allow_external_cassandra_access = true,
  $allow_external_postgresql_access = true
) {

  include ufw

  if tagged('ssh_service') {
    ufw::allow { 'ssh':
      port => 22,
    }
  }

  if tagged('zabbix_agent_service') {
    ufw::allow { 'zabbix-agent':
      port  => 10050,
      proto => 'tcp'
    }
  }

  if tagged("zabbix_server_service") {
    ufw::allow { 'zabbix-server':
      port  => 10051,
      proto => 'tcp',
    }
  }

  if tagged("zabbix_frontend_service") {
    firewall { 'zabbix-frontend':
      port  => 80,
      proto => 'tcp',
    }
  }

  if $allow_external_cassandra_access {
    if tagged("cassandra_service") {
      ufw::allow { 'cassandra-internode':
        port  => 7000,
        proto => 'tcp',
      }
      ufw::allow { 'cassandra-client':
        port  => 9160,
        proto => 'tcp',
      }
    }
  }

  if $allow_external_postgresql_access {
    if tagged("postgresql_service") {
      ufw::allow { 'postgresql':
        port  => 5432,
        proto => 'tcp',
      }
    }
  }

}
