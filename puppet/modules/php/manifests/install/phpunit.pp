class php::install::phpunit {
  $require = Class['php::install::php']

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  exec { 'php-discover-phpunit':
    command => 'pyrus channel-discover pear.phpunit.de',
    creates => "/opt/phpfarm/inst/current-bin/phpunit",
    require => $require,
  }

  exec { 'php-discover-symfony':
    command => 'pyrus channel-discover pear.symfony.com',
    creates => "/opt/phpfarm/inst/current-bin/phpunit",
    require => $require,
  }

  exec { 'php-discover-ez':
    command => 'pyrus channel-discover components.ez.no',
    creates => "/opt/phpfarm/inst/current-bin/phpunit",
    require => $require,
  }

  exec { 'php-install-phpunit':
    command => 'pyrus install phpunit/phpunit',
    timeout => 0,
    creates => "/opt/phpfarm/inst/current-bin/phpunit",
    require => Exec['php-discover-phpunit', 'php-discover-symfony', 'php-discover-ez'],
  }

  file { '/usr/bin/phpunit':
    ensure  => link,
    target  => "/opt/phpfarm/inst/current-bin/phpunit",
    require => Exec['php-install-phpunit'],
  }
}