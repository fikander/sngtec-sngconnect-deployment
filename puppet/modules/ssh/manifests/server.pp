class ssh::server {

  package { "openssh-server":
    ensure => present,
  }

}
