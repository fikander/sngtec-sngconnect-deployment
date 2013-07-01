define postgresql_service::site () {

  postgresql::db { $name:
    user     => $name,
    password => $name,
  }

}
