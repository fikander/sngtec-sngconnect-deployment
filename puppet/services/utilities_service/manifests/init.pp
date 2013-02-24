class utilities_service {

  $packages = [
    'ack-grep',
    'htop',
    'netcat',
    'bash-completion',
    'vim',
    'screen',
    'curl',
    'lshw',
    'tree',
    'xz-utils',
    'bzip2',
  ]

  package { $packages:
    ensure => present,
  }

}
