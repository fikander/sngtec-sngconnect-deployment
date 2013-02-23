class cassandra_service (
  $listening_address,
  $seed_addresses
) {

  include oracle_java6
  include cassandra::server

  Exec {
     path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
  }

  define nofile_limit () {
    limits::limits { "${name}_nofile":
      ensure     => present,
      user       => $name,
      limit_type => "nofile",
      hard       => "32768",
      soft       => "32768",
    }
  }

  define memlock_limit () {
    limits::limits { "${name}_memlock":
      ensure     => present,
      user       => $name,
      limit_type => "memlock",
      hard       => "unlimited",
      soft       => "unlimited",
    }
  }

  define as_limit () {
    limits::limits { "${name}_as":
      ensure     => present,
      user       => $name,
      limit_type => "as",
      hard       => "unlimited",
      soft       => "unlimited",
    }
  }

  $limit_users = [
    "root",
    "cassandra",
  ]

  nofile_limit  { $limit_users: }
  memlock_limit { $limit_users: }
  as_limit      { $limit_users: }

  sysctl::value { "vm.max_map_count":
    value => 131072,
  }

  sysctl::value { "vm.swappiness":
    value => 0,
  }

  file { "/etc/cassandra":
    ensure => directory,
  }
  file { "/etc/cassandra/cassandra.yaml":
    ensure  => present,
    content => template("cassandra_service/cassandra.yaml"),
    notify  => Service["cassandra"],
    require => File["/etc/cassandra"],
  }

  service { "cassandra":
    ensure  => running,
    require => [
      Class["oracle_java6"],
      Class["cassandra::server"],
    ],
  }

}
