class zip::install {
  if ! defined(Package['zip']) {
    package { 'zip':
      ensure => present,
    }
  }

  if ! defined(Package['unzip']) {
    package { 'unzip':
      ensure => present,
    }
  }
}