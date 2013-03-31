class php::install::composer {
  $require = Class['php::install::php']

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  exec { 'php-install-composer':
    cwd     => "/opt/phpfarm/inst/current-bin",
    command => 'curl -s https://getcomposer.org/installer | php',
    timeout => 0,
    creates => "/opt/phpfarm/inst/current-bin/composer.phar",
    require => $require,
  }

  file { '/usr/bin/composer':
    ensure  => link,
    target  => "/opt/phpfarm/inst/current-bin/composer.phar",
    require => Exec['php-install-composer'],
  }
}