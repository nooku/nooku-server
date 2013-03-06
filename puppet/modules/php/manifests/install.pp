class php::install {
  define php::install::source {
    include php::params

    $version = $name

    $short_version = $version ? {
      /^5\.3/ => '53',
      /^5\.4/ => '54',
    }

    $url = "http://www.php.net/get/php-${version}.tar.gz/from/this/mirror"

    $configure = $version ? {
      /^5\.3/ => $php::params::configure_53,
      /^5\.4/ => $php::params::configure_54,
    }

    if ! defined(Package['build-essential']) {
      package { 'build-essential':
        ensure => present,
      }
    }

    if ! defined(Package['libxml2-dev']) {
      package { 'libxml2-dev':
        ensure => present,
      }
    }

    if ! defined(Package['libpcre3-dev']) {
      package { 'libpcre3-dev':
        ensure => present,
      }
    }

    if ! defined(Package['libbz2-dev']) {
      package { 'libbz2-dev':
        ensure => present,
      }
    }

    if ! defined(Package['libcurl4-openssl-dev']) {
      package { 'libcurl4-openssl-dev':
        ensure => present,
      }
    }

    if ! defined(Package['libjpeg-dev']) {
      package { 'libjpeg-dev':
        ensure => present,
      }
    }

    if ! defined(Package['libpng12-dev']) {
      package { 'libpng12-dev':
        ensure => present,
      }
    }

    if ! defined(Package['libxpm-dev']) {
      package { 'libxpm-dev':
        ensure => present,
      }
    }

    if ! defined(Package['libfreetype6-dev']) {
      package { 'libfreetype6-dev':
        ensure => present,
      }
    }

    if ! defined(Package['libmysqlclient-dev']) {
      package { 'libmysqlclient-dev':
        ensure => present,
      }
    }

    if ! defined(Package['libt1-dev']) {
      package { 'libt1-dev':
        ensure => present,
      }
    }

    if ! defined(Package['libgd2-xpm-dev']) {
      package { 'libgd2-xpm-dev':
        ensure => present,
      }
    }

    if ! defined(Package['libgmp-dev']) {
      package { 'libgmp-dev':
        ensure => present,
      }
    }

    if ! defined(Package['libsasl2-dev']) {
      package { 'libsasl2-dev':
        ensure => present,
      }
    }

    if ! defined(Package['libmhash-dev']) {
      package { 'libmhash-dev':
        ensure => present,
      }
    }

    if ! defined(Package['freetds-dev']) {
      package { 'freetds-dev':
        ensure => present,
      }
    }

    if ! defined(Package['libpspell-dev']) {
      package { 'libpspell-dev':
        ensure => present,
      }
    }

    if ! defined(Package['libsnmp-dev']) {
      package { 'libsnmp-dev':
        ensure => present,
      }
    }

    if ! defined(Package['libtidy-dev']) {
      package { 'libtidy-dev':
        ensure => present,
      }
    }

    if ! defined(Package['libxslt1-dev']) {
      package { 'libxslt1-dev':
        ensure => present,
      }
    }

    if ! defined(Package['libmcrypt-dev']) {
      package { 'libmcrypt-dev':
        ensure => present,
      }
    }

    exec { "download-${version}":
      cwd       => '/tmp',
      command   => "wget -O php-${version}.tar.gz ${url}",
      creates   => "/tmp/php-${version}.tar.gz",
      timeout   => 3600,
      logoutput => 'on_failure',
    }

    exec { "extract-${version}":
      cwd => '/tmp',
      command   => "tar xzvpf php-${version}.tar.gz -C /usr/src",
      unless    => "ls /usr/src/php-${version}",
      logoutput => 'on_failure',
      creates   => "/usr/src/php-${version}",
      require   => Exec["download-${version}"],
    }

    exec { "configure-${version}":
      cwd       => "/usr/src/php-${version}",
      command   => "./configure $configure",
      path      => [ "/usr/src/php-${version}", '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ],
      timeout   => 0,
      logoutput => 'on_failure',
      require   => [ Exec["extract-${version}"], Package['build-essential'], Package['libxml2-dev'], Package['libpcre3-dev'], Package['libbz2-dev'], Package['libcurl4-openssl-dev'], Package['libjpeg-dev'], Package['libpng12-dev'], Package['libxpm-dev'], Package['libfreetype6-dev'], Package['libmysqlclient-dev'], Package['libt1-dev'], Package['libgd2-xpm-dev'], Package['libgmp-dev'], Package['libsasl2-dev'], Package['libmhash-dev'], Package['freetds-dev'], Package['libpspell-dev'], Package['libsnmp-dev'], Package['libtidy-dev'], Package['libxslt1-dev'], Package['libmcrypt-dev'] ],
    }

    exec { "make-${version}":
      cwd       => "/usr/src/php-${version}",
      command   => "make",
      timeout   => 0,
      logoutput => 'on_failure',
      require   => Exec["configure-${version}"],
    }

    exec { "make-install-${version}":
      cwd       => "/usr/src/php-${version}",
      command   => "make install",
      timeout   => 0,
      logoutput => 'on_failure',
      require   => Exec["make-${version}"],
    }

    exec { "pear-channel-update-${version}":
      cwd       => "/usr/local/php${short_version}/bin",
      command   => 'pear channel-update pear.php.net',
      path      => [ "/usr/local/php${short_version}/bin", '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ],
      timeout   => 0,
      logoutput => on_failure,
      require   => Exec["make-install-${version}"],
    }

    exec { "pear-upgrade-all-${version}":
      cwd       => "/usr/local/php${short_version}/bin",
      command   => 'pear upgrade-all',
      path      => [ "/usr/local/php${short_version}/bin", '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ],
      timeout   => 0,
      logoutput => on_failure,
      require   => Exec["pear-channel-update-${version}"],
    }

    exec { "pear-auto-discover-${version}":
      cwd       => "/usr/local/php${short_version}/bin",
      command   => 'pear config-set auto_discover 1',
      path      => [ "/usr/local/php${short_version}/bin", '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ],
      timeout   => 0,
      logoutput => on_failure,
      require   => Exec["pear-upgrade-all-${version}"],
    }

    exec { "pear-install-phpunit-${version}":
      cwd       => "/usr/local/php${short_version}/bin",
      command   => 'pear install pear.phpunit.de/PHPUnit',
      path      => [ "/usr/local/php${short_version}/bin", '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ],
      timeout   => 0,
      logoutput => on_failure,
      require   => Exec["pear-auto-discover-${version}"],
    }

    exec { "install-composer-${version}":
      cwd       => "/usr/local/php${short_version}/bin",
      command   => "php -r \"eval('?>'.file_get_contents('https://getcomposer.org/installer'));\"",
      path      => [ "/usr/local/php${short_version}/bin", '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ],
      timeout   => 0,
      logoutput => on_failure,
      require   => Exec["make-install-${version}"],
    }
  }

  php::install::source { '5.3.22': }
  php::install::source { '5.4.12': }
}