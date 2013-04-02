class php::install::phpunit {
  $require = Anchor['php::install::php_54']

  Exec {
    timeout => 0,
  }

  File {
    owner => 'root',
    group => 'root',
    mode  => '0755',
  }

  $php_version = '5.4.13'

  if ! defined(Exec['php-pear-channel-update']) {
    exec { 'php-pear-channel-update':
      command => 'pear channel-update pear.php.net',
      require => $require,
    }
  }

  if ! defined(Exec['php-pear-upgrade-all']) {
    exec { 'php-pear-upgrade-all':
      command => 'pear upgrade-all',
      require => Exec['php-pear-channel-update'],
    }
  }

  if ! defined(Exec['php-pear-discover-phpunit']) {
    exec { 'php-pear-discover-phpunit':
      command => 'pear channel-discover pear.phpunit.de',
      require => Exec['php-pear-upgrade-all'],
    }
  }

  if ! defined(Exec['php-pear-discover-symfony']) {
    exec { 'php-pear-discover-symfony':
      command => 'pear channel-discover pear.symfony.com',
      require => Exec['php-pear-upgrade-all'],
    }
  }

  if ! defined(Exec['php-pear-discover-ez']) {
    exec { 'php-pear-discover-ez':
      command => 'pear channel-discover components.ez.no',
      require => Exec['php-pear-upgrade-all'],
    }
  }

  exec { 'php-pear-install-phpunit':
    command => 'pear install phpunit/PHPUnit',
    creates => '/usr/local/php-${php_version}/bin/phpunit',
    require => Exec['php-pear-discover-phpunit', 'php-pear-discover-symfony', 'php-pear-discover-ez'],
  }

  file { '/usr/bin/phpunit':
    ensure  => link,
    target  => '/usr/local/php-${php_version}/bin/phpunit',
    require => Exec['php-pear-install-phpunit'],
  }

  anchor { 'php::install::phpunit':
    require => File['/usr/bin/phpunit'],
  }
}