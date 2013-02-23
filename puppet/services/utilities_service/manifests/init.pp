class utilities_service {

  $packages = [
    'ack-grep',
    'htop',
    'netcat',
    'bash-completion',
    'vim-nox',
    'screen',
    'curl',
    'lshw',
    'tree',
  ]

  package { $packages:
    ensure => present,
  }

}
