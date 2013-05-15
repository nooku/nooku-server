class php::config::php_53 {
  $require = Anchor['php::install']

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

  file { '/etc/php-5.3/php.ini':
    ensure  => file,
    source  => 'puppet:///modules/php/etc/php-5.3/php.ini',
    notify  => Class['php::service'],
    require => File['/etc/php-5.3'],
  }

  file { '/etc/php-5.3/php-fpm.conf.default':
    ensure  => absent,
    require => File['/etc/php-5.3'],
  }

  file { '/etc/php-5.3/php-fpm.conf':
    ensure  => file,
    source  => 'puppet:///modules/php/etc/php-5.3/php-fpm.conf',
    notify  => Class['php::service'],
    require => File["/etc/php-5.3"],
  }

  file { '/etc/php-5.3/conf.d/xdebug.ini':
    ensure  => file,
    source  => 'puppet:///modules/php/etc/php-5.3/conf.d/xdebug.ini',
    notify  => Class['php::service'],
    require => File['/etc/php-5.3/conf.d'],
  }

  file { '/etc/php-5.3/conf.d/yaml.ini':
    ensure  => file,
    source  => 'puppet:///modules/php/etc/php-5.3/conf.d/yaml.ini',
    notify  => Class['php::service'],
    require => File['/etc/php-5.3/conf.d'],
  }

  file { '/etc/init.d/php-fpm-5.3':
    ensure  => file,
    source  => 'puppet:///modules/php/etc/init.d/php-fpm-5.3',
    mode    => '0755',
    notify  => Class['php::service'],
    require => $require,
  }

  anchor { 'php::config::php_53':
    require => File[
      '/etc/php-5.3/php.ini',
      '/etc/php-5.3/php-fpm.conf',
      '/etc/php-5.3/conf.d/xdebug.ini',
      '/etc/php-5.3/conf.d/yaml.ini',
      '/etc/init.d/php-fpm-5.3'
    ],
  }
}