class php::params {
  $xdebug_53 = '/usr/local/php53/lib/php/extensions/no-debug-non-zts-20090626/xdebug.so'
  $xdebug_54 = '/usr/local/php54/lib/php/extensions/no-debug-non-zts-20100525/xdebug.so'

  $conf_dir_53 = '/etc/php53'
  $conf_dir_54 = '/etc/php54'

  $configure_53 = "\
    --enable-fpm\
    --prefix=/usr/local/php53\
    --sysconfdir=/etc/php53\
    --with-config-file-path=/etc/php53\
    --with-config-file-scan-dir=/etc/php53/conf.d\
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

  $configure_54 ="\
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