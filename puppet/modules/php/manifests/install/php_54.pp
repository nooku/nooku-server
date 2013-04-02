class php::install::php_54 {
  Exec {
    timeout => 0,
  }

  File {
    owner => 'root',
    group => 'root',
    mode  => '0755',
  }

  realize(Package[$php::install::packages])

  $version = '5.4.13'

  $configure = "\
    --enable-fpm\
    --prefix=/usr/local/php-${version}\
    --sysconfdir=/etc/php-5.4\
    --with-config-file-path=/etc/php-5.4\
    --with-config-file-scan-dir=/etc/php-5.4/conf.d\
    --enable-bcmath\
    --enable-calendar\
    --enable-ctype\
    --enable-exif\
    --enable-mbstring\
    --enable-ftp\
    --enable-sockets\
    --enable-sysvmsg\
    --enable-pcntl\
    --enable-zip\
    --enable-soap\
    --with-bz2\
    --with-curl\
    --with-gettext\
    --with-gd\
    --enable-gd-native-ttf\
    --enable-exif\
    --with-freetype-dir=/usr\
    --with-jpeg-dir=/usr\
    --with-t1lib=/usr\
    --with-mcrypt\
    --with-openssl\
    --with-kerberos\
    --with-iconv\
    --with-xsl\
    --with-xmlrpc\
    --with-zlib\
    --with-mysql=mysqlnd\
    --with-mysqli=mysqlnd\
    --with-pdo-mysql=mysqlnd\
    --with-imap-ssl"

  exec { 'php-download-5.4':
    cwd     => '/tmp',
    command => "wget -O php-${version}.tar.gz http://www.php.net/get/php-${version}.tar.gz/from/this/mirror",
    creates => "/usr/local/php-${version}/bin/php",
  }

  exec { 'php-extract-5.4':
    cwd     => '/tmp',
    command => "tar xzpf php-${version}.tar.gz",
    creates => "/usr/local/php-${version}/bin/php",
    require => Exec['php-download-5.4'],
  }

  exec { 'php-configure-5.4':
    cwd     => "/tmp/php-${version}",
    path    => [ "/tmp/php-${version}", '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
    command => "./configure ${configure}",
    creates => "/usr/local/php-${version}/bin/php",
    require => [ Exec['php-extract-5.4'], Package[$php::install::packages] ],
  }

  exec { 'php-make-5.4':
    cwd     => "/tmp/php-${version}",
    command => 'make',
    creates => "/usr/local/php-${version}/bin/php",
    timeout => 0,
    require => Exec['php-configure-5.4'],
  }

  exec { 'php-make-install-5.4':
    cwd     => "/tmp/php-${version}",
    command => 'make install',
    creates => "/usr/local/php-${version}/bin/php",
    timeout => 0,
    require => Exec['php-make-5.4'],
  }

  exec { 'php-install-xdebug-5.4':
    cwd     => "/usr/local/php-${version}/bin",
    path    => [ "/usr/local/php-${version}/bin", '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
    command => 'pecl install xdebug',
    creates => '/usr/local/php-${version}/lib/php/extensions/no-debug-non-zts-20100525/xdebug.so',
    timeout => 0,
    require => Exec['php-make-install-5.4'],
  }

  exec { 'php-install-yaml-5.4':
    cwd     => "/usr/local/php-${version}/bin",
    path    => [ "/usr/local/php-${version}/bin", '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin' ],
    command => 'pecl install yaml',
    creates => '/usr/local/php-${version}/lib/php/extensions/no-debug-non-zts-20100525/yaml.so',
    require => Exec['php-make-install-5.4'],
  }

  file { '/usr/bin/php':
    ensure  => link,
    target  => "/usr/local/php-${version}/bin/php",
    require => Exec['php-make-install-5.4'],
  }

  file { '/usr/bin/php-config':
    ensure  => link,
    target  => "/usr/local/php-${version}/bin/php-config",
    require => Exec['php-make-install-5.4'],
  }

  file { '/usr/bin/pear':
    ensure  => link,
    target  => "/usr/local/php-${version}/bin/pear",
    require => Exec['php-make-install-5.4'],
  }

  file { '/usr/bin/pecl':
    ensure  => link,
    target  => "/usr/local/php-${version}/bin/pecl",
    require => Exec['php-make-install-5.4'],
  }

  file { '/usr/bin/phar':
    ensure  => link,
    target  => "/usr/local/php-${version}/bin/phar.phar",
    require => Exec['php-make-install-5.4'],
  }

  file { '/usr/bin/phpize':
    ensure  => link,
    target  => "/usr/local/php-${version}/bin/phpize",
    require => Exec['php-make-install-5.4'],
  }

  anchor { 'php::install::php_54':
    require => [
      Exec[ 'php-make-install-5.4', 'php-install-xdebug-5.4', 'php-install-yaml-5.4' ],
      File[ '/usr/bin/php', '/usr/bin/php-config', '/usr/bin/pear', '/usr/bin/pecl', '/usr/bin/phar', '/usr/bin/phpize' ]
    ],
  }
}