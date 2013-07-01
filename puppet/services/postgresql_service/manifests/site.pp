class postgresql_service::site (
  $codename
) {

  postgresql::db { $codename:
    user     => $codename,
    password => $codename,
  }

}
