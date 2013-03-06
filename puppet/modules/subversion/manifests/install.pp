class subversion::install {
  if ! defined(Package['subversion']) {
    package { 'subversion':
      ensure => present,
    }
  }
}