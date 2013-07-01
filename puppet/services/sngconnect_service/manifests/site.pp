define sngconnect_service::site (
  $listening_port,
  $session_secret,
  $cassandra_servers,
  $database_server,
) {

  require sngconnect_service

  $listening_address = "127.0.0.1"
  $cassandra_keyspace = $name
  $database_name = $name
  $database_user = $name
  $database_password = $name
  $upload_path = "/var/lib/sngconnect/${name}"
  $pid_file = "/var/run/sngconnect/${name}.pid"
  $log_file = "/var/log/sngconnect/${name}.log"
  $configuration_file = "/etc/sngconnect/${name}.ini"

  File {
    owner => "root",
    group => "root",
  }

  file { $configuration_file:
    ensure  => present,
    content => template("sngconnect_service/configuration.ini.erb"),
  }

  file { "/etc/init.d/${name}":
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
