define monit_service::site (
  $port
) {

  require monit_service

  monit::monitor { $name:
    pidfile => "/var/run/sngconnect/$name.pid",
    group   => "sngconnect",
    checks  => [
      "if failed host 127.0.0.1 port ${port} protocol http and request '/' with timeout 10 seconds then restart",
    ],
  }
  Sngconnect_service::Site[$name] -> Monit::Monitor[$name]

}
