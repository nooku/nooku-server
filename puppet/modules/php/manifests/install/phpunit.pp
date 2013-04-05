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

  if ! defined(Exec["php-pear-channel-update-${php_version}"]) {
    exec { "php-pear-channel-update-${php_version}":
      command => 'pear channel-update pear.php.net',
      require => $require,
    }
  }

  if ! defined(Exec["php-pear-upgrade-all-${php_version}"]) {
    exec { "php-pear-upgrade-all-${php_version}":
      command => 'pear upgrade-all',
      require => Exec["php-pear-channel-update-${php_version}"],
    }
  }

  if ! defined(Exec["php-pear-discover-phpunit--${php_version}"]) {
    exec { "php-pear-discover-phpunit-${php_version}":
      command => 'pear channel-discover pear.phpunit.de',
      creates => "/usr/local/php-${php_version}/lib/php/.channels/pear.phpunit.de.reg",
      require => Exec["php-pear-upgrade-all-${php_version}"],
    }
  }

  if ! defined(Exec["php-pear-discover-symfony-${php_version}"]) {
    exec { "php-pear-discover-symfony-${php_version}":
      command => 'pear channel-discover pear.symfony.com',
      creates => "/usr/local/php-${php_version}/lib/php/.channels/pear.symfony.com.reg",
      require => Exec["php-pear-upgrade-all-${php_version}"],
    }
  }

  if ! defined(Exec["php-pear-discover-ez-${php_version}"]) {
    exec { "php-pear-discover-ez-${php_version}":
      command => 'pear channel-discover components.ez.no',
      creates => "/usr/local/php-${php_version}/lib/php/.channels/components.ez.no.reg",
      require => Exec["php-pear-upgrade-all-${php_version}"],
    }
  }

  exec { "php-pear-install-phpunit-${php_version}":
    command => 'pear install phpunit/PHPUnit',
    creates => "/usr/local/php-${php_version}/bin/phpunit",
    require => Exec[
      "php-pear-discover-phpunit-${php_version}",
      "php-pear-discover-symfony-${php_version}",
      "php-pear-discover-ez-${php_version}"
    ],
  }

  file { '/usr/bin/phpunit':
    ensure  => link,
    target  => "/usr/local/php-${php_version}/bin/phpunit",
    require => Exec["php-pear-install-phpunit-${php_version}"],
  }

  anchor { 'php::install::phpunit':
    require => File['/usr/bin/phpunit'],
  }
}