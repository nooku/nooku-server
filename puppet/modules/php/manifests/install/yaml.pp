class php::install::yaml {
  $require = Class['php::install::php']

  $php_version_53 = '5.3.23'
  $php_version_54 = '5.4.13'
  $yaml_version   = '1.0.0'

  exec { 'php-download-yaml':
    cwd     => '/tmp',
    command => "wget http://pecl.php.net/get/yaml-${yaml_version}.tgz",
    creates => '/opt/phpfarm/inst/php-${php_version_54}/lib/php/extensions/debug-non-zts-20100525/yaml.so',
    require => $require,
  }

  exec { 'php-extract-yaml':
    cwd     => '/tmp',
    command => "tar -xzf yaml-${yaml_version}.tgz",
    creates => '/opt/phpfarm/inst/php-${php_version_54}/lib/php/extensions/debug-non-zts-20100525/yaml.so',
    require => Exec['php-download-yaml'],
  }

  exec { 'php-phpize-yaml-5.3':
    cwd     => "/tmp/yaml-${yaml_version}",
    command => "/opt/phpfarm/inst/bin/phpize-${php_version_53}",
    creates => '/opt/phpfarm/inst/php-${php_version_53}/lib/php/extensions/debug-non-zts-20090626/yaml.so',
    require => Exec['php-extract-yaml'],
  }

  exec { 'php-configure-yaml-5.3':
    cwd     => "/tmp/yaml-${yaml_version}",
    path    => [ "/tmp/yaml-${yaml_version}", '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ],
    command => "./configure --with-php-config=/opt/phpfarm/inst/bin/php-config-${php_version_53}",
    creates => '/opt/phpfarm/inst/php-${php_version_53}/lib/php/extensions/debug-non-zts-20090626/yaml.so',
    require => Exec['php-phpize-yaml-5.3'],
  }

  exec { 'php-make-yaml-5.3':
    cwd     => "/tmp/yaml-${yaml_version}",
    command => 'make',
    creates => '/opt/phpfarm/inst/php-${php_version_53}/lib/php/extensions/debug-non-zts-20090626/yaml.so',
    require => Exec['php-configure-yaml-5.3'],
  }

  exec { 'php-make-install-yaml-5.3':
    cwd     => "/tmp/yaml-${yaml_version}",
    command => 'make install',
    creates => '/opt/phpfarm/inst/php-${php_version_53}/lib/php/extensions/debug-non-zts-20090626/yaml.so',
    require => Exec['php-make-yaml-5.3'],
  }

  exec { 'php-phpize-yaml-5.4':
    cwd     => "/tmp/yaml-${yaml_version}",
    command => "/opt/phpfarm/inst/php-${php_version_54}/bin/phpize",
    creates => '/opt/phpfarm/inst/php-${php_version_54}/lib/php/extensions/debug-non-zts-20100525/yaml.so',
    require => Exec['php-make-install-yaml-5.3'],
  }

  exec { 'php-configure-yaml-5.4':
    cwd     => "/tmp/yaml-${yaml_version}",
    path    => [ "/tmp/yaml-${yaml_version}", '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ],
    command => "./configure --with-php-config=/opt/phpfarm/inst/bin/php-config-${php_version_54}",
    creates => '/opt/phpfarm/inst/php-${php_version_54}/lib/php/extensions/debug-non-zts-20100525/yaml.so',
    require => Exec['php-phpize-yaml-5.4'],
  }

  exec { 'php-make-yaml-5.4':
    cwd     => "/tmp/yaml-${yaml_version}",
    command => 'make',
    creates => '/opt/phpfarm/inst/php-${php_version_54}/lib/php/extensions/debug-non-zts-20100525/yaml.so',
    require => Exec['php-configure-yaml-5.4'],
  }

  exec { 'php-make-install-yaml-5.4':
    cwd     => "/tmp/yaml-${yaml_version}",
    command => 'make install',
    creates => '/opt/phpfarm/inst/php-${php_version_54}/lib/php/extensions/debug-non-zts-20100525/yaml.so',
    require => Exec['php-make-yaml-5.4'],
  }
}