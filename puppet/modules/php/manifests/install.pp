class php::install {
  if ! defined(Package['build-essential']) {
    package { 'build-essential':
      ensure => present,
    }
  }

  if ! defined(Package['autoconf']) {
    package { 'autoconf':
      ensure => present,
    }
  }

  if ! defined(Package['libxml2-dev']) {
    package { 'libxml2-dev':
      ensure => present,
    }
  }

  if ! defined(Package['libpcre3-dev']) {
    package { 'libpcre3-dev':
      ensure => present,
    }
  }

  if ! defined(Package['libbz2-dev']) {
    package { 'libbz2-dev':
      ensure => present,
    }
  }

  if ! defined(Package['libcurl4-openssl-dev']) {
    package { 'libcurl4-openssl-dev':
      ensure => present,
    }
  }

  if ! defined(Package['libjpeg-dev']) {
    package { 'libjpeg-dev':
      ensure => present,
    }
  }

  if ! defined(Package['libpng12-dev']) {
    package { 'libpng12-dev':
      ensure => present,
    }
  }

  if ! defined(Package['libxpm-dev']) {
    package { 'libxpm-dev':
      ensure => present,
    }
  }

  if ! defined(Package['libfreetype6-dev']) {
    package { 'libfreetype6-dev':
      ensure => present,
    }
  }

  if ! defined(Package['libmysqlclient-dev']) {
    package { 'libmysqlclient-dev':
      ensure => present,
    }
  }

  if ! defined(Package['libt1-dev']) {
    package { 'libt1-dev':
      ensure => present,
    }
  }

  if ! defined(Package['libgd2-xpm-dev']) {
    package { 'libgd2-xpm-dev':
      ensure => present,
    }
  }

  if ! defined(Package['libgmp-dev']) {
    package { 'libgmp-dev':
      ensure => present,
    }
  }

  if ! defined(Package['libsasl2-dev']) {
    package { 'libsasl2-dev':
      ensure => present,
    }
  }

  if ! defined(Package['libmhash-dev']) {
    package { 'libmhash-dev':
      ensure => present,
    }
  }

  if ! defined(Package['freetds-dev']) {
    package { 'freetds-dev':
      ensure => present,
    }
  }

  if ! defined(Package['libpspell-dev']) {
    package { 'libpspell-dev':
      ensure => present,
    }
  }

  if ! defined(Package['libsnmp-dev']) {
    package { 'libsnmp-dev':
      ensure => present,
    }
  }

  if ! defined(Package['libtidy-dev']) {
    package { 'libtidy-dev':
      ensure => present,
    }
  }

  if ! defined(Package['libxslt1-dev']) {
    package { 'libxslt1-dev':
      ensure => present,
    }
  }

  if ! defined(Package['libmcrypt-dev']) {
    package { 'libmcrypt-dev':
      ensure => present,
    }
  }

  if ! defined(Package['libyaml-dev']) {
    package { 'libyaml-dev':
      ensure => present,
    }
  }

  include php::install::php_53
  include php::install::php_54
  include php::install::phpunit
  include php::install::composer
  include php::install::phpalizer

  anchor { 'php::install':
    require => Anchor[
      'php::install::php_53',
      'php::install::php_54',
      'php::install::composer',
      'php::install::phpalizer',
      'php::install::phpunit'
    ],
  }
}