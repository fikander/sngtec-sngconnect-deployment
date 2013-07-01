class sngconnect_service::site (
  $codename,
  $listening_port,
  $session_secret,
  $cassandra_servers,
  $database_server,
) {

  require sngconnect_service

  $listening_address = "127.0.0.1"
  $cassandra_keyspace = $codename
  $database_name = $codename
  $database_user = $codename
  $database_password = $codename
  $upload_path = "/var/lib/sngconnect/${codename}"
  $pid_file = "/var/run/sngconnect/${codename}.pid"
  $log_file = "/var/log/sngconnect/${codename}.log"
  $configuration_file = "/etc/sngconnect/${codename}.ini"

  File {
    owner => "root",
    group => "root",
  }

  file { $configuration_file:
    ensure  => present,
    content => template("sngconnect_service/configuration.ini.erb"),
  }

  file { "/etc/init.d/${codename}":
    ensure  => present,
    content => template("sngconnect_service/init_script.sh.erb"),
    mode    => "755",
  }

  file { $upload_path:
    ensure => directory,
    group  => "sngconnect",
    mode   => "775",
  }
  file { "${upload_path}/devices":
    ensure => directory,
    group  => "sngconnect",
    mode   => "775",
  }
  file { "${upload_path}/appearance":
    ensure => directory,
    group  => "sngconnect",
    mode   => "775",
  }

}
