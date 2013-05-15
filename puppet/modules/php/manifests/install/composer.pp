class php::install::composer {
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

  exec { 'php-install-composer':
    cwd     => "/usr/local/php-${php_version}/bin",
    command => 'curl -s https://getcomposer.org/installer | php',
    creates => "/usr/local/php-${php_version}/bin/composer.phar",
    require => $require,
  }

  file { '/usr/bin/composer':
    ensure  => link,
    target  => "/usr/local/php-${php_version}/bin/composer.phar",
    require => Exec['php-install-composer'],
  }

  anchor { 'php::install::composer':
    require => File['/usr/bin/composer'],
  }
}