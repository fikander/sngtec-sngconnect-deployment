class nginx_service {

  class { 'nginx':
    confd_purge => true,
  }

}
