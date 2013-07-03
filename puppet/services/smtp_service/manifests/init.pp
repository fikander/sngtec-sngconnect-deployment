class smtp_service {

  package { 'exim4':
    ensure => present,
  }

  exec { 'update-exim4.conf':
    command     => 'update-exim4.conf',
    refreshonly => true,
    require     => Package['exim4'],
  }

  file { '/etc/exim4/update-exim4.conf.conf':
    ensure  => present,
    content => template('smtp_service/update-exim4.conf.conf.erb'),
    require => Package['exim4'],
    notify  => Exec['update-exim4.conf'],
  }

}
