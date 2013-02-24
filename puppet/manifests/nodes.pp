node "common" {
  $zabbix_server_address = "127.0.0.1"

  include user::virtual
  include user::administrators
  include ntp
  include utilities_service
  include ssh_service
}

node "monitor" inherits "common" {
  class { "postgresql_service":
    listening_address     => "127.0.0.1",
    allow_connection_from => "127.0.0.1/32",
  }
  class { "zabbix_server_service":
    listening_address => $ipaddress_eth1,
    database_address  => "127.0.0.1",
  }
  include monit_service
  include firewall_service
}

node "application" inherits "common" {
  class { "zabbix_agent_service":
    listening_address     => $ipaddress_eth1,
    zabbix_server_address => $zabbix_server_address,
  }
  include monit_service
  include firewall_service
}

node "database" inherits "common" {
  class { "postgresql_service":
    listening_address     => $ipaddress_eth1,
    allow_connection_from => "192.168.50.0/24",
  }
  class { "zabbix_agent_service":
    listening_address     => $ipaddress_eth1,
    zabbix_server_address => $zabbix_server_address,
  }
  include monit_service
  include firewall_service
}

node "cassandra" inherits "common" {
  class { "cassandra_service":
    listening_address => $ipaddress_eth1,
    seed_addresses    => [
      "192.168.50.4",
    ],
  }
  class { "zabbix_agent_service":
    listening_address     => $ipaddress_eth1,
    zabbix_server_address => $zabbix_server_address,
  }
  include monit_service
  include firewall_service
}

node /^\w+-mon.*$/ inherits "monitor" {
}
node /^\w+-app-\d+.*$/ inherits "application" {
}
node /^\w+-db-\d+.*$/ inherits "database" {
}
node /^\w+-cass-\d+.*$/ inherits "cassandra" {
}
