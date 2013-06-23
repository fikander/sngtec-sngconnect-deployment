node "common" {
  Exec {
    path => [
      '/usr/local/sbin',
      '/usr/local/bin',
      '/usr/sbin',
      '/usr/bin',
      '/sbin',
      '/bin',
    ],
  }

  include user::virtual
  include user::administrators
  include ntp
  include utilities_service
  include ssh_service
}

node "base" inherits "common" {
  class { "postgresql_service":
    listening_address     => $ipaddress_lo,
    allow_connection_from => "${ipaddress_lo}/32",
  }
  class { "cassandra_service":
    listening_address => $ipaddress_lo,
    seed_addresses    => [
      $ipaddress_lo,
    ],
  }
  class { "sngconnect_service":
    database_address => "sng-base-1",
  }
  include monit_service
  class { "firewall_service":
    allow_external_cassandra_access  => false,
    allow_external_postgresql_access => false,
  }
}

node /\w+-base-\d+$/ inherits "base" {}
