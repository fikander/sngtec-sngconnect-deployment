class nginx_service {

  class { 'nginx':
    confd_purge   => true,
    server_tokens => off,
  }

  file { '/srv/default':
    ensure => directory,
  }

  nginx::resource::vhost { 'default':
    listen_options      => 'default',
    www_root            => '/srv/default',
    location_cfg_append => {
      'return' => '404',
    },
    require => File['/srv/default'],
  }

}
