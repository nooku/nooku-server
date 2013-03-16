class ubuntu {
  include ubuntu::packages

  exec { 'hold-grub':
    command => 'apt-mark hold grub-common grub-pc grub-pc-bin grub2-common',
    unless  => "dpkg --get-selections | grep -P '^grub[2]?-[-a-z]+\\s+hold$'",
  }

  exec { 'ubuntu-update':
    command => 'apt-get -q -y update',
  }

  exec { 'ubuntu-upgrade':
    command => 'apt-get -q -y upgrade',
    timeout => 0,
    require => [ Exec['hold-grub'], Exec['ubuntu-update'] ],
  }

  realize(
    Package['curl'],
    Package['git'],
    Package['subversion'],
    Package['zip'],
    Package['unzip'],
    Package['vim'],
  )
}