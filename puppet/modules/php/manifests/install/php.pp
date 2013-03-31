class php::install::php {
  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  $php_version_53 = '5.3.23'
  $php_version_54 = '5.4.13'

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
    'libmcrypt-dev',
    'libyaml-dev',
  ]

  package { $packages:
    ensure => present,
  }

  exec { 'php-clone-phpfarm':
    cwd     => '/opt',
    command => 'git clone git://git.code.sf.net/p/phpfarm/code phpfarm',
  }

  file { '/opt/phpfarm/src/custom-options-5.3.sh':
    ensure  => file,
    source  => 'puppet:///modules/php/opt/phpfarm/src/custom-options-5.3.sh',
    require => Exec['php-clone-phpfarm'],
  }

  exec { 'php-compile-53':
    cwd     => '/opt/phpfarm/src',
    path    => [ '/opt/phpfarm/src', '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ],
    command => "./compile.sh ${php_version_53}",
    timeout => 0,
    creates => "/opt/phpfarm/inst/php-${php_version_53}",
    require => [ File['/opt/phpfarm/src/custom-options-5.3.sh'], Package[$packages] ],
  }

  file { '/opt/phpfarm/src/custom-options-5.4.sh':
    ensure  => file,
    source  => 'puppet:///modules/php/opt/phpfarm/src/custom-options-5.4.sh',
    require => Exec['php-clone-phpfarm'],
  }

  exec { 'php-compile-54':
    cwd     => '/opt/phpfarm/src',
    path    => [ '/opt/phpfarm/src', '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ],
    command => "./compile.sh ${php_version_54}",
    timeout => 0,
    creates => "/opt/phpfarm/inst/php-${php_version_54}",
    require => [ File['/opt/phpfarm/src/custom-options-5.4.sh'], Package[$packages] ],
  }

  file { '/usr/bin/php':
    ensure  => link,
    target  => "/opt/phpfarm/inst/current-bin/php",
    require => [ Exec['php-compile-53'], Exec['php-compile-54'] ],
  }

  file { '/usr/bin/php-config':
    ensure  => link,
    target  => "/opt/phpfarm/inst/current-bin/php-config",
    require => Exec['php-set-version'],
  }

  file { '/usr/bin/phar':
    ensure  => link,
    target  => "/opt/phpfarm/inst/current-bin/phar.phar",
    require => Exec['php-set-version'],
  }

  file { '/usr/bin/phpize':
    ensure  => link,
    target  => "/opt/phpfarm/inst/current-bin/phpize",
    require => Exec['php-set-version'],
  }

  file { '/usr/bin/pyrus':
    ensure  => link,
    target  => "/opt/phpfarm/inst/current-bin/pyrus",
    require => Exec['php-set-version'],
  }

  exec { 'php-set-version':
    path    => [ '/opt/phpfarm/inst/bin', '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ],
    command => "switch-phpfarm ${php_version_54}",
    require => File['/usr/bin/php'],
  }
}