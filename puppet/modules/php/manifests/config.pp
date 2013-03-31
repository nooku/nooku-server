class php::config {
  $require = Class['php::install::php', 'php::install::xdebug', 'php::install::yaml']

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  file { '/etc/php-5.3':
    ensure  => directory,
    require => $require,
  }

  file { '/etc/php-5.3/conf.d':
    ensure  => directory,
    require => File['/etc/php-5.3'],
  }

  file { "/etc/php-5.3/php.ini":
    ensure  => file,
    source  => 'puppet:///modules/php/etc/php-5.3/php.ini',
    require => File['/etc/php-5.3'],
  }

  file { "/etc/php-5.3/conf.d/xdebug.ini":
    ensure  => file,
    source  => 'puppet:///modules/php/etc/php-5.3/conf.d/xdebug.ini',
    require => File['/etc/php-5.3/conf.d'],
  }

  file { '/etc/php-5.4':
    ensure  => directory,
    require => $require,
  }

  file { '/etc/php-5.4/conf.d':
    ensure  => directory,
    require => File['/etc/php-5.4'],
  }

  file { "/etc/php-5.4/php.ini":
    ensure  => file,
    source  => 'puppet:///modules/php/etc/php-5.4/php.ini',
    require => File['/etc/php-5.4'],
  }

  file { "/etc/php-5.4/conf.d/xdebug.ini":
    ensure  => file,
    source  => 'puppet:///modules/php/etc/php-5.4/conf.d/xdebug.ini',
    require => File['/etc/php-5.4/conf.d'],
  }
}