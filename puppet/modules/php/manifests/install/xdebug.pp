class php::install::xdebug {
  $require = Class['php::install::php']

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  $php_version_53 = '5.3.23'
  $php_version_54 = '5.4.13'
  $xdebug_version = '2.2.2'

  file { "/tmp/php-${php_version_53}":
    ensure  => directory,
    require => $require,
  }

  exec { 'php-download-xdebug-5.3':
    cwd     => "/tmp/php-${php_version_53}",
    command => "wget http://xdebug.org/files/xdebug-${xdebug_version}.tgz",
    creates => "/opt/phpfarm/inst/php-${php_version_53}/lib/php/extensions/debug-non-zts-20090626/xdebug.so",
    require => File["/tmp/php-${php_version_53}"],
  }

  exec { 'php-extract-xdebug-5.3':
    cwd     => "/tmp/php-${php_version_53}",
    command => "tar -xzf xdebug-${xdebug_version}.tgz",
    creates => "/opt/phpfarm/inst/php-${php_version_53}/lib/php/extensions/debug-non-zts-20090626/xdebug.so",
    require => Exec['php-download-xdebug-5.3'],
  }

  exec { 'php-phpize-xdebug-5.3':
    cwd     => "/tmp/php-${php_version_53}/xdebug-${xdebug_version}",
    command => "/opt/phpfarm/inst/bin/phpize-${php_version_53}",
    creates => "/opt/phpfarm/inst/php-${php_version_53}/lib/php/extensions/debug-non-zts-20090626/xdebug.so",
    require => Exec['php-extract-xdebug-5.3'],
  }

  exec { 'php-configure-xdebug-5.3':
    cwd     => "/tmp/php-${php_version_53}/xdebug-${xdebug_version}",
    path    => [ "/tmp/php-${php_version_53}/xdebug-${xdebug_version}", '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ],
    command => "./configure --enable-xdebug --with-php-config=/opt/phpfarm/inst/bin/php-config-${php_version_53}",
    creates => "/opt/phpfarm/inst/php-${php_version_53}/lib/php/extensions/debug-non-zts-20090626/xdebug.so",
    require => Exec['php-phpize-xdebug-5.3'],
  }

  exec { 'php-make-xdebug-5.3':
    cwd     => "/tmp/php-${php_version_53}/xdebug-${xdebug_version}",
    command => 'make',
    creates => "/opt/phpfarm/inst/php-${php_version_53}/lib/php/extensions/debug-non-zts-20090626/xdebug.so",
    require => Exec['php-configure-xdebug-5.3'],
  }

  exec { 'php-make-install-xdebug-5.3':
    cwd     => "/tmp/php-${php_version_53}/xdebug-${xdebug_version}",
    command => 'make install',
    creates => "/opt/phpfarm/inst/php-${php_version_53}/lib/php/extensions/debug-non-zts-20090626/xdebug.so",
    require => Exec['php-make-xdebug-5.3'],
  }

  file { "/tmp/php-${php_version_54}":
    ensure  => directory,
    require => $require,
  }

  exec { 'php-download-xdebug-5.4':
    cwd     => "/tmp/php-${php_version_54}",
    command => "wget http://xdebug.org/files/xdebug-${xdebug_version}.tgz",
    creates => "/opt/phpfarm/inst/php-${php_version_54}/lib/php/extensions/debug-non-zts-20100525/xdebug.so",
    require => File["/tmp/php-${php_version_54}"],
  }

  exec { 'php-extract-xdebug-5.4':
    cwd     => "/tmp/php-${php_version_54}",
    command => "tar -xzf xdebug-${xdebug_version}.tgz",
    creates => "/opt/phpfarm/inst/php-${php_version_54}/lib/php/extensions/debug-non-zts-20100525/xdebug.so",
    require => Exec['php-download-xdebug-5.4'],
  }

  exec { 'php-phpize-xdebug-5.4':
    cwd     => "/tmp/php-${php_version_54}/xdebug-${xdebug_version}",
    command => "/opt/phpfarm/inst/php-${php_version_54}/bin/phpize",
    creates => "/opt/phpfarm/inst/php-${php_version_54}/lib/php/extensions/debug-non-zts-20100525/xdebug.so",
    require => Exec['php-extract-xdebug-5.4'],
  }

  exec { 'php-configure-xdebug-5.4':
    cwd     => "/tmp/php-${php_version_54}/xdebug-${xdebug_version}",
    path    => [ "/tmp/php-${php_version_54}/xdebug-${xdebug_version}", '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ],
    command => "./configure --enable-xdebug --with-php-config=/opt/phpfarm/inst/bin/php-config-${php_version_54}",
    creates => "/opt/phpfarm/inst/php-${php_version_54}/lib/php/extensions/debug-non-zts-20100525/xdebug.so",
    require => Exec['php-phpize-xdebug-5.4'],
  }

  exec { 'php-make-xdebug-5.4':
    cwd     => "/tmp/php-${php_version_54}/xdebug-${xdebug_version}",
    command => 'make',
    creates => "/opt/phpfarm/inst/php-${php_version_54}/lib/php/extensions/debug-non-zts-20100525/xdebug.so",
    require => Exec['php-configure-xdebug-5.4'],
  }

  exec { 'php-make-install-xdebug-5.4':
    cwd     => "/tmp/php-${php_version_54}/xdebug-${xdebug_version}",
    command => 'make install',
    creates => "/opt/phpfarm/inst/php-${php_version_54}/lib/php/extensions/debug-non-zts-20100525/xdebug.so",
    require => Exec['php-make-xdebug-5.4'],
  }
}