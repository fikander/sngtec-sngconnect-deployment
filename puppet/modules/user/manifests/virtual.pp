class user::virtual {

  define ssh_user ( $password, $key_type, $key, $groups = [] ) {
    user { $name:
      ensure     => present,
      managehome => true,
      shell      => '/bin/bash',
      groups     => $groups,
      password   => $password,
    }
    ssh_authorized_key { '${name}_key':
      key  => $key,
      type => $key_type,
      user => $name,
    }
  }

  @ssh_user {
    'msiedlarek':
      password => '$6$0koqNLas$XyJvvVdshFOA9zcNOtc9FySSOlHcZX7PHS/UD/t7EBSEWTw7qL0RluF8BU2Pi3Z6jhWAGZhQkY5qFiR7LhxWc.',
      key_type => 'ssh-rsa',
      key      => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQCvONPmMdTmHqiehwBnoEzZkjshKriZtpYs+qUu2vuSuZbxOjxo+/4g+DL5BfvSzt78/slDZ7ITzo7jdCG7/puQ5Ijl8OEiK10+kjUB/Tt5kp0dbmURKj2BnQbKYEOjIFVz9hEOKB/pvAuXj7uXcltyWO2UjLZOIyZT5lOAnSFcA9aTw1SnbYxGVROJqxHX49/l4ITqOH1Pz7WJoDngvt6RiUTRKv5zT/RvMfr62WG+QeXoCkT1O4cRHu83amIEOKt4vjKIYQy5aNNykEMepNXWn61IH8RLhbf7GNIfuBqJf4PuGNa9GU7uKpqSpeUkIDqXtpzaeCcjEwRvHUZeDMkI3F3TJsazVTdbqClSuABU/NYafLJNKQDW5a4TYysRG4wYUWtZ1TWve3uvEvsnSd2yCHiZe0H1ohPxmwjKkDornJqztsIuz+v/CnS2uletcHewDHPEUl0FgnqWXFhS+3MZ57/5VMhVfU8e/qa6goy7UXDnbCQ3eos2jmGukGy5fUafm+CppL+L9yURPPfcBWWHuN0B0ikvWigJVVaUd5koyyEvlpGg51PxWycfV4SLky1QLTNVlW/QF/A/fzTgej8+1+4s8A6yKa3GaS21pOpveGUeI2a/y29Z7hms1FE+FTAxtG7mAOB4oB7lngB2Oeslj6Y8OjN+vrc3V4saJlbJ4Q==',
      groups   => [
        'adm',
        'admin',
        'sudo',
      ],
  }

}
