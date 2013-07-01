define nginx_service::site (
  $port,
  $domain
) {

  require nginx_service

  nginx::resource::upstream { $name:
    ensure  => present,
    members => [
      "localhost:${port}",
    ],
  }

  nginx::resource::vhost { $domain:
    ensure => present,
    proxy  => "http://${name}",
  }

}
