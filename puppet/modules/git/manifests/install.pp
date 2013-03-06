class git::install {
  if ! defined(Package['git']) {
    package { 'git':
      ensure => present,
    }
  }
}