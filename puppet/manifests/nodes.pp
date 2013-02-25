define host_name ($ip) {
  host { $name:
    ip => $ip ? {
      $::ipaddress_eth1 => "127.0.1.1",
      default           => $ip,
    },
  }
}

node "common" {
  $zabbix_server_address = "192.168.50.2"

  include user::virtual
  include user::administrators
  include ntp
  include utilities_service
  include ssh_service

  host_name {
    "dev-mon":    ip => "192.168.50.2";
    "dev-app-1":  ip => "192.168.50.3";
    "dev-db-1":   ip => "192.168.50.4";
    "dev-cass-1": ip => "192.168.50.5";
  }
}

node "monitor" inherits "common" {
  class { "postgresql_service":
    listening_address     => "127.0.0.1",
    allow_connection_from => "127.0.0.1/32",
  }
  class { "zabbix_server_service":
    listening_address => $ipaddress_eth1,
    database_address  => "127.0.0.1",
    database_name     => "zabbix",
    database_user     => "zabbix",
    database_password => "zabbix",
  }
  class { "zabbix_frontend_service":
    zabbix_server_address    => $zabbix_server_address,
    zabbix_database_address  => "127.0.0.1",
    zabbix_database_name     => "zabbix",
    zabbix_database_user     => "zabbix",
    zabbix_database_password => "zabbix",
  }
  class { "zabbix_agent_service":
    listening_addresses   => [
      $ipaddress_lo,
      $ipaddress_eth1,
    ],
    zabbix_server_address => $zabbix_server_address,
  }
  include monit_service
  include firewall_service
}

node "application" inherits "common" {
  class { "zabbix_agent_service":
    listening_addresses   => [
      $ipaddress_lo,
      $ipaddress_eth1,
    ],
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
    listening_addresses   => [
      $ipaddress_lo,
      $ipaddress_eth1,
    ],
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
    listening_addresses   => [
      $ipaddress_lo,
      $ipaddress_eth1,
    ],
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
