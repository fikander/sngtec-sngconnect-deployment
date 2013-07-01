class sngconnect_service (
  $database_address
) {

  $packages = [
    'binutils',
    'gcc',
    'g++',
    'git',
    'python2.7',
    'python2.7-dev',
    'python-virtualenv',
    'libxml2-dev',
    'libxslt1-dev',
    'postgresql-server-dev-all',
  ]

  package { $packages:
    ensure => present,
  }

  File {
    owner => "root",
    group => "root",
  }

  file { "/root/.ssh":
    ensure => directory,
    mode   => "700",
  }
  file { "/root/.ssh/staging_deployment":
    ensure  => present,
    mode    => "600",
    source  => "puppet:///modules/sngconnect_service/ssh/staging_deployment",
    require => File["/root/.ssh"],
  }
  file { "/root/.ssh/staging_deployment.pub":
    ensure  => present,
    mode    => "644",
    source  => "puppet:///modules/sngconnect_service/ssh/staging_deployment.pub",
    require => File["/root/.ssh"],
  }
  file { "/root/.ssh/config":
    ensure  => present,
    mode    => "600",
    source  => "puppet:///modules/sngconnect_service/ssh/config",
    require => File["/root/.ssh"],
  }
  file { "/root/.ssh/known_hosts":
    ensure  => present,
    mode    => "644",
    source  => "puppet:///modules/sngconnect_service/ssh/known_hosts",
    require => File["/root/.ssh"],
  }

  user { "sngconnect":
    ensure  => present,
    home    => "/opt/sngconnect",
    shell   => "/bin/false",
    system  => true
  }
  file { "/opt/sngconnect":
    ensure  => directory,
    owner   => "sngconnect",
    group   => "sngconnect",
    require => User["sngconnect"],
  }

  exec { "/opt/sngconnect/bin":
    command => "/usr/bin/virtualenv --python=python2.7 /opt/sngconnect",
    creates => "/opt/sngconnect/bin",
    user    => "sngconnect",
    require => [
      User["sngconnect"],
      Package[$packages],
      File["/opt/sngconnect"],
    ],
  }

  exec { "/opt/sngconnect/lib/python2.7/site-packages/sngconnect":
    command => "/opt/sngconnect/bin/pip install git+ssh://git@github.com/sngtec/sngconnect.git",
    creates => "/opt/sngconnect/lib/python2.7/site-packages/sngconnect",
    timeout => 1800,
    user    => "sngconnect",
    require => [
      User["sngconnect"],
      Package[$packages],
      Exec["/opt/sngconnect/bin"],
      File["/root/.ssh/staging_deployment"],
      File["/root/.ssh/config"],
      File["/root/.ssh/known_hosts"],
    ],
  }

  file { "/etc/sngconnect":
    ensure => directory,
  }
  file { "/var/run/sngconnect":
    ensure => directory,
    group  => "sngconnect",
    mode   => "775",
  }
  file { "/var/log/sngconnect":
    ensure => directory,
    group  => "sngconnect",
    mode   => "775",
  }
  file { "/var/lib/sngconnect":
    ensure => directory,
  }

}
