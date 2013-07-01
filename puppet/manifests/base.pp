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
  class { "sngconnect_service::site":
    codename => "hoven_sngconnect_com",
    listening_port => 8001,
    session_secret => "7iT28vXpcYnogucsBe9g9gxppApNKQ",
    cassandra_servers => [
      "127.0.0.1",
    ],
    database_server => "127.0.0.1",
  }
  class { "sngconnect_service::site":
    codename => "connect_snghome_com",
    listening_port => 8002,
    session_secret => "TsvMKqDCKBEL7Uvj6nHrnYRcM9a26A",
    cassandra_servers => [
      "127.0.0.1",
    ],
    database_server => "127.0.0.1",
  }
  include nginx_service
  class { "nginx_service::site":
    codename => "hoven_sngconnect_com",
    port     => 8001,
    domain   => "hoven.sngconnect.com",
  }
  class { "nginx_service::site":
    codename => "connect_snghome_com",
    port     => 8002,
    domain   => "connect.snghome.com",
  }
  include monit_service
  class { "firewall_service":
    allow_external_cassandra_access  => false,
    allow_external_postgresql_access => false,
  }
}

node /\w+-base-\d+$/ inherits "base" {}
