class vim::install {
  if ! defined(Package['vim']) {
    package { 'vim':
      ensure => present,
    }
  }
}