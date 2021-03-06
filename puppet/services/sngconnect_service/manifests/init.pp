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

  exec { "/opt/sngconnect":
    command   => "/usr/bin/virtualenv --python=python2.7 /opt/sngconnect",
    creates   => "/opt/sngconnect",
    logoutput => "on_failure",
    require   => [
      Package[$packages],
    ],
  }

  exec { "/opt/sngconnect/lib/python2.7/site-packages/sngconnect":
#    command   => "/opt/sngconnect/bin/pip install git+ssh://git@github.com/sngtec/sngconnect.git",
    command   => "/opt/sngconnect/bin/pip install git+ssh://git@kdtower.synology.me/repositories/sngconnect.git",
    creates   => "/opt/sngconnect/lib/python2.7/site-packages/sngconnect",
    timeout   => 1800,
    logoutput => "on_failure",
    require   => [
      Package[$packages],
      Exec["/opt/sngconnect"],
      File["/root/.ssh/staging_deployment"],
      File["/root/.ssh/config"],
      File["/root/.ssh/known_hosts"],
    ],
  }

  file { "/opt/sngconnect/lib/python2.7/site-packages/sngconnect/static/compressed":
    ensure => directory,
    owner  => "sngconnect",
    group  => "sngconnect",
    require => [
      User["sngconnect"],
      Exec["/opt/sngconnect/lib/python2.7/site-packages/sngconnect"],
    ]
  }
  file
  { "/opt/sngconnect/lib/python2.7/site-packages/sngconnect/static/.webassets-cache":
    ensure => directory,
    owner  => "sngconnect",
    group  => "sngconnect",
    require => [
      User["sngconnect"],
      Exec["/opt/sngconnect/lib/python2.7/site-packages/sngconnect"],
    ]
  }

  file { "/etc/sngconnect":
    ensure => directory,
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
