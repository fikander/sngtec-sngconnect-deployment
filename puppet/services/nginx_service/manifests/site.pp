class nginx_service::site (
  $codename,
  $port,
  $domain
) {

   nginx::resource::upstream { $codename:
     ensure  => present,
     members => [
       "localhost:${port}",
     ],
   }

   nginx::resource::vhost { $domain:
     ensure      => present,
     proxy       => "http://${codename}",
   }

}
