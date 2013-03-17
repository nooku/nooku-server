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
    'libmcrypt-dev'
  ]

  @package { $packages:
    ensure => present,
  }

  php::install::source { ['5.3.22', '5.4.12']: }

  $php_bin = '/usr/local/php54/bin'
  $require = Anchor['php::install::source::5.4.12']

  file { '/usr/bin/php':
    ensure  => link,
    target  => "${php_bin}/php",
    require => $require,
  }

  file { '/usr/bin/php-config':
    ensure  => link,
    target  => "${php_bin}/php-config",
    require => $require,
  }

  file { '/usr/bin/pear':
    ensure  => link,
    target  => "${php_bin}/pear",
    require => $require,
  }

  file { '/usr/bin/pecl':
    ensure  => link,
    target  => "${php_bin}/pecl",
    require => $require,
  }

  file { '/usr/bin/phar':
    ensure  => link,
    target  => "${php_bin}/phar.phar",
    require => $require,
  }

  file { '/usr/bin/phpize':
    ensure  => link,
    target  => "${php_bin}/phpize",
    require => $require,
  }

  exec { 'pear-channel-update':
    command => 'pear channel-update pear.php.net',
    timeout => 0,
    require => File['/usr/bin/php', '/usr/bin/pear'],
  }

  exec { 'pear-upgrade-all':
    command     => 'pear upgrade-all',
    timeout     => 0,
    require     => File['/usr/bin/php', '/usr/bin/pear'],
  }

  exec { 'pear-discover-phpunit':
    command => 'pear channel-discover pear.phpunit.de',
    creates => "${php_bin}/phpunit",
    timeout => 0,
    require => File['/usr/bin/php', '/usr/bin/pear'],
  }

  exec { 'pear-discover-symfony':
    command => 'pear channel-discover pear.symfony.com',
    creates => "${php_bin}/phpunit",
    timeout => 0,
    require => Exec['pear-upgrade-all'],
  }

  exec { 'pear-discover-ez':
    command => 'pear channel-discover components.ez.no',
    creates => "${php_bin}/phpunit",
    timeout => 0,
    require => File['/usr/bin/php', '/usr/bin/pear'],
  }

  exec { 'pear-install-phpunit':
    command => 'pear install phpunit/PHPUnit',
    creates => "${php_bin}/phpunit",
    timeout => 0,
    require => Exec['pear-discover-phpunit', 'pear-discover-symfony', 'pear-discover-ez'],
  }

  file { '/usr/bin/phpunit':
    ensure  => link,
    target  => "${php_bin}/phpunit",
    require => Exec['pear-install-phpunit'],
  }

  exec { 'install-composer':
    cwd     => "${php_bin}",
    command => 'curl -s https://getcomposer.org/installer | php',
    creates => "${php_bin}/composer.phar",
    timeout => 0,
    require => File['/usr/bin/php'],
  }

  file { '/usr/bin/composer':
    ensure  => link,
    target  => "${php_bin}/composer.phar",
    require => Exec['install-composer'],
  }

  exec { 'install-php-analyzer':
    cwd     => '/usr/local',
    command => 'composer create-project scrutinizer/php-analyzer:dev-master',
    creates => '/usr/local/php-analyzer',
    timeout => 0,
    require => File['/usr/bin/composer'],
  }

  file { '/usr/bin/phpalizer':
    ensure  => link,
    target  => '/usr/local/php-analyzer/bin/phpalizer',
    require => Exec['install-php-analyzer'],
  }
}