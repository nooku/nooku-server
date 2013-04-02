class php::install {
  $packages = [
    'build-essential',
    'autoconf',
    'libxml2-dev',
    'libpcre3-dev',
    'libbz2-dev',
    'libcurl4-openssl-dev',
    'libjpeg-dev',
    'libpng12-dev',
    'libxpm-dev',
    'libfreetype6-dev',
    'libmysqlclient-dev',
    'libt1-dev',
    'libgd2-xpm-dev',
    'libgmp-dev',
    'libsasl2-dev',
    'libmhash-dev',
    'freetds-dev',
    'libpspell-dev',
    'libsnmp-dev',
    'libtidy-dev',
    'libxslt1-dev',
    'libmcrypt-dev',
    'libyaml-dev',
  ]

  @package { $packages:
    ensure => present,
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