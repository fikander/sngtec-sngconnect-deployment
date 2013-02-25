class cassandra::server {

  include apt

  apt::source { "datastax_community":
    location    => "http://debian.datastax.com/community",
    release     => "stable",
    repos       => "main",
  }

  apt::key { "B999A372":
    key        => "B999A372",
    key_source => "http://debian.datastax.com/debian/repo_key",
  }

  package { "cassandra":
    ensure  => "1.2.1",
    require => [
      Apt::Source["datastax_community"],
      Apt::Key["B999A372"],
    ],
  }

  file { "/etc/logrotate.d/cassandra":
    content => template("cassandra/cassandra.logrotate.erb"),
    require => Package["cassandra"],
  }

}
