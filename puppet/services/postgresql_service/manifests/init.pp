class postgresql_service (
  $listening_address,
  $allow_connection_from,
  $database_name,
  $user_name,
  $user_password
) {

  Exec {
     path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
  }

  class { 'postgresql::server':
    config_hash => {
      ip_mask_allow_all_users => $allow_connection_from,
      listen_addresses        => $listening_address,
    }
  }

  postgresql::db { $database_name:
    user     => $user_name,
    password => $user_password,
    require  => Class["postgresql::server"],
  }

  sysctl::value { "kernel.shmmax":
    value => "17179869184",
  }

  sysctl::value { "kernel.shmall":
    value => "4194304",
  }

  sysctl::value { "vm.overcommit_memory":
    value => "2",
  }

}
