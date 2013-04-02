class php::install::php_53 {
  Exec {
    timeout => 0,
  }

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  realize(Package[$php::install::packages])

  $version = '5.3.23'

  $configure = "\
    --enable-fpm\
    --prefix=/usr/local/php-${version}\
    --sysconfdir=/etc/php-5.3\
    --with-config-file-path=/etc/php-5.3\
    --with-config-file-scan-dir=/etc/php-5.3/conf.d\
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

  exec { 'php-download-5.3':
    cwd     => '/tmp',
    command => "wget -O php-${version}.tar.gz http://www.php.net/get/php-${version}.tar.gz/from/this/mirror",
    creates => "/usr/local/php-${version}/bin/php",
  }

  exec { 'php-extract-5.3':
    cwd     => '/tmp',
    command => "tar xzpf php-${version}.tar.gz",
    creates => "/usr/local/php-${version}/bin/php",
    require => Exec['php-download-5.3'],
  }

  exec { 'php-configure-5.3':
    cwd     => "/tmp/php-${version}",
    path    => [ "/tmp/php-${version}", '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ],
    command => "./configure ${configure}",
    creates => "/usr/local/php-${version}/bin/php",
    require => [ Exec['php-extract-5.3'], Package[$php::install::packages] ],
  }

  exec { 'php-make-5.3':
    cwd     => "/tmp/php-${version}",
    command => 'make',
    creates => "/usr/local/php-${version}/bin/php",
    timeout => 0,
    require => Exec['php-configure-5.3'],
  }

  exec { 'php-make-install-5.3':
    cwd     => "/tmp/php-${version}",
    command => 'make install',
    creates => "/usr/local/php-${version}/bin/php",
    timeout => 0,
    require => Exec['php-make-5.3'],
  }

  exec { 'php-install-xdebug-5.3':
    cwd     => "/usr/local/php-${version}/bin",
    path    => [ "/usr/local/php-${version}/bin", '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ],
    command => 'pecl install xdebug',
    creates => '/usr/local/php-${version}/lib/php/extensions/no-debug-non-zts-20090626/xdebug.so',
    timeout => 0,
    require => Exec['php-make-install-5.3'],
  }

  exec { 'php-install-yaml-5.3':
    cwd     => "/usr/local/php-${version}/bin",
    path    => [ "/usr/local/php-${version}/bin", '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ],
    command => 'pecl install yaml',
    creates => '/usr/local/php-${version}/lib/php/extensions/no-debug-non-zts-20090626/yaml.so',
    require => Exec['php-make-install-5.3'],
  }

  anchor { 'php::install::php_53':
    require => Exec[ 'php-make-install-5.3', 'php-install-xdebug-5.3', 'php-install-yaml-5.3' ],
  }
}