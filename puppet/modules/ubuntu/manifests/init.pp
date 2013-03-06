class ubuntu {
  exec { 'hold-grub':
    command   => 'apt-mark hold grub-common grub-pc grub-pc-bin grub2-common',
    unless    => "dpkg --get-selections | grep -P '^grub[2]?-[-a-z]+\\s+hold$'",
    logoutput => on_failure,
    notify    => Exec['ubuntu-upgrade'],
  }

  exec { 'ubuntu-update':
    command   => 'apt-get -q -y update',
    logoutput => on_failure,
  }

  exec { 'ubuntu-upgrade':
    command     => 'apt-get -q -y upgrade',
    logoutput   => on_failure,
    refreshonly => true,
    require     => [ Exec['hold-grub'], Exec['ubuntu-update'] ],
  }
}