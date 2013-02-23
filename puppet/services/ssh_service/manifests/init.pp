class ssh_service {

  include ssh::client
  include ssh::server

  Augeas {
    notify  => Service["ssh"],
  }

  augeas { "/files/etc/ssh/sshd_conf/PermitRootLogin":
    context => "/files/etc/ssh/sshd_config",
    changes => "set PermitRootLogin no",
  }

  augeas { "/files/etc/ssh/sshd_conf/PasswordAuthentication":
    context => "/files/etc/ssh/sshd_config",
    changes => "set PasswordAuthentication no",
  }

  service { "ssh":
    ensure  => running,
    require => Class["ssh::server"],
  }

}
