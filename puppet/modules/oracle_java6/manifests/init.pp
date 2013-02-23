class oracle_java6 {

  include apt

  apt::ppa { "ppa:webupd8team/java":
  }

  exec { "autoaccept_oracle_license":
    command => "/bin/echo oracle-java6-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections",
    unless  => "/usr/bin/debconf-show oracle-java6-installer | /bin/grep -q \"shared/accepted-oracle-license-v1-1: true\"",
    require => Apt::Ppa["ppa:webupd8team/java"],
  }

  package { "oracle-java6-installer":
    require => Exec["autoaccept_oracle_license"],
  }

}
