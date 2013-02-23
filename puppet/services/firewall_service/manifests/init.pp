class firewall_service {

  package { 'iptables-persistent':
    ensure => present,
  }

  exec { 'iptables-save':
    command     => '/sbin/iptables-save > /etc/iptables/rules.v4',
    refreshonly => true,
    require     => Package['iptables-persistent'],
  }
  exec { 'ip6tables-save':
    command     => '/sbin/ip6tables-save > /etc/iptables/rules.v6',
    refreshonly => true,
    require     => Package['iptables-persistent'],
  }

  Firewall {
    notify => [
      Exec['iptables-save'],
      Exec['ip6tables-save'],
    ],
  }

  firewall { '000 INPUT allow related and established':
    state  => ['RELATED', 'ESTABLISHED'],
    action => 'accept',
    proto  => 'all',
  }
  firewall { '000 INPUT allow related and established (IPv6)':
    state    => ['RELATED', 'ESTABLISHED'],
    action   => 'accept',
    proto    => 'all',
    provider => 'ip6tables',
  }

  firewall { '001 accept all icmp requests':
    proto  => 'icmp',
    action => 'accept',
  }
  firewall { '001 accept all icmp requests (IPv6)':
    proto    => 'ipv6-icmp',
    action   => 'accept',
    provider => 'ip6tables',
  }

  firewall { '002 INPUT allow loopback':
    iniface => 'lo',
    action  => 'accept',
    proto   => 'all',
  }
  firewall { '002 INPUT allow loopback (IPv6)':
    iniface  => 'lo',
    action   => 'accept',
    proto    => 'all',
    provider => 'ip6tables',
  }

  firewall { '998 INPUT deny all other requests':
    action => 'reject',
    proto  => 'all',
    reject => 'icmp-host-prohibited',
  }
  firewall { '998 INPUT deny all other requests (IPv6)':
    action   => 'reject',
    reject   => 'icmp6-adm-prohibited',
    proto    => 'all',
    provider => 'ip6tables',
  }

  firewall { '999 FORWARD deny all other requests':
    chain  => 'FORWARD',
    action => 'reject',
    proto  => 'all',
    reject => 'icmp-host-prohibited',
  }
  firewall { '999 FORWARD deny all other requests (IPv6)':
    chain    => 'FORWARD',
    action   => 'reject',
    proto    => 'all',
    reject   => 'icmp6-adm-prohibited',
    provider => 'ip6tables',
  }

  if tagged("ssh_service") {
    firewall { '100 allow ssh':
      state  => ['NEW'],
      dport  => '22',
      proto  => 'tcp',
      action => 'accept',
    }
    firewall { '100 allow ssh (IPv6)':
      state    => ['NEW'],
      dport    => '22',
      proto    => 'tcp',
      action   => 'accept',
      provider => 'ip6tables',
    }
  }

  if tagged("cassandra_service") {
    firewall { '500 allow cassandra inter-node communication':
      state  => ['NEW'],
      dport  => '7000',
      proto  => 'tcp',
      action => 'accept',
    }
    firewall { '500 allow cassandra client communication':
      state  => ['NEW'],
      dport  => '9160',
      proto  => 'tcp',
      action => 'accept',
    }
  }

  if tagged("postgresql_service") {
    firewall { '500 allow postgresql':
      state  => ['NEW'],
      dport  => '5432',
      proto  => 'tcp',
      action => 'accept',
    }
  }

}
