class php::params::54 {
  $xdebug   = '/usr/local/php54/lib/php/extensions/no-debug-non-zts-20100525/xdebug.so'
  $yaml     = '/usr/local/php54/lib/php/extensions/no-debug-non-zts-20100525/yaml.so'

  $conf_dir = '/etc/php54'

  $configure = "\
    --enable-fpm\
    --prefix=/usr/local/php54\
    --sysconfdir=/etc/php54\
    --with-config-file-path=/etc/php54\
    --with-config-file-scan-dir=/etc/php54/conf.d\
    --enable-bcmath\
    --enable-calendar\
    --enable-ctype\
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
}