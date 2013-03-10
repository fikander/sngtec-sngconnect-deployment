class sngconnect_service {

  $installation_path = "/opt/sngconnect"

  File {
    owner => "root",
    group => "root",
  }

  file { "/root/.ssh":
    ensure => directory,
    mode   => "0500",
  }
  file { "/root/.ssh/staging_deployment":
    ensure  => present,
    mode    => "0400",
    source  => "puppet:///modules/sngconnect_service/ssh/staging_deployment",
    require => File["/root/.ssh"],
  }
  file { "/root/.ssh/staging_deployment.pub":
    ensure  => present,
    mode    => "0400",
    source  => "puppet:///modules/sngconnect_service/ssh/staging_deployment.pub",
    require => File["/root/.ssh"],
  }
  file { "/root/.ssh/config":
    ensure  => present,
    mode    => "0400",
    source  => "puppet:///modules/sngconnect_service/ssh/config",
    require => File["/root/.ssh"],
  }
  file { "/root/.ssh/known_hosts":
    ensure  => present,
    mode    => "0400",
    source  => "puppet:///modules/sngconnect_service/ssh/known_hosts",
    require => File["/root/.ssh"],
  }

  exec { "clone_sngconnect_repository":
    command => "/usr/bin/git clone git@github.com:sngtec/sngconnect.git $installation_path",
    creates => $installation_path,
    require => [
      File["/root/.ssh/staging_deployment"],
      File["/root/.ssh/config"],
      File["/root/.ssh/known_hosts"],
    ],
  }

}
