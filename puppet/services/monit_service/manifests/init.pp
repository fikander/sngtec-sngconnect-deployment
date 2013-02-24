class monit_service {

  class { "monit":
    interval => 20,
    admin    => "admin@example.com",
  }

  if tagged("ssh_service") {
    monit::monitor { "ssh":
      pidfile => "/var/run/sshd.pid",
      ip_port => "22",
    }
  }

  if tagged("postgresql_service") {
    monit::monitor { "postgresql":
      pidfile => "/var/run/postgresql/9.1-main.pid",
      ip_port => "5432",
    }
  }

  if tagged("cassandra_service") {
    monit::monitor { "cassandra":
      pidfile => "/var/run/cassandra.pid",
      ip_port => "7000",
    }
  }

}
