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
    ensure                 => present,
    rewrite_www_to_non_www => true,
    proxy                  => "http://${name}",
    require                => Nginx::Resource::Upstream[$name],
  }

}
