define php::install {
  $version = $name

  include php::params

  $work_dir = '/var/tmp'
  $url      = "http://www.php.net/get/php-${version}.tar.gz/from/hu1.php.net/mirror"

  package { 'build-essential':
    ensure => installed,
  }

  package { [ 'libxml2-dev', 'libpcre3-dev', 'libbz2-dev', 'libcurl4-openssl-dev', 'libjpeg-dev', 'libpng12-dev', 'libxpm-dev', 'libfreetype6-dev', 'libmysqlclient-dev', 'libt1-dev', 'libgd2-xpm-dev', 'libgmp-dev', 'libsasl2-dev', 'libmhash-dev', 'freetds-dev', 'libpspell-dev', 'libsnmp-dev', 'libtidy-dev', 'libxslt1-dev', 'libmcrypt-dev' ]:
    ensure => installed,
  }

  exec { "download-${version}":
    cwd         => '/tmp',
    command     => "wget -O php-${version}.tar.gz ${url}",
    creates     => "/tmp/php-${version}.tar.gz",
    timeout     => 3600,
    logoutput => 'on_failure',
  }

  exec { "extract-${version}":
    cwd => '/tmp',
    command     => "tar xzvpf php-${version}.tar.gz -C /usr/src",
    unless      => "ls /usr/src/php-${version}",
    logoutput => 'on_failure',
    creates     => "/usr/src/php-${version}",
    require     => Exec["download-${version}"],
  }

  exec { "configure-${version}":
    cwd => "/usr/src/php-${version}",
    command => "./configure $php::params::configure",
    path => [ "/usr/src/php-${version}", '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ],
    timeout => 0,
    logoutput => 'on_failure',
    require => [ Exec["extract-${version}"], Package['build-essential'], Package['libxml2-dev'], Package['libpcre3-dev'], Package['libbz2-dev'], Package['libcurl4-openssl-dev'], Package['libjpeg-dev'], Package['libpng12-dev'], Package['libxpm-dev'], Package['libfreetype6-dev'], Package['libmysqlclient-dev'], Package['libt1-dev'], Package['libgd2-xpm-dev'], Package['libgmp-dev'], Package['libsasl2-dev'], Package['libmhash-dev'], Package['freetds-dev'], Package['libpspell-dev'], Package['libsnmp-dev'], Package['libtidy-dev'], Package['libxslt1-dev'], Package['libmcrypt-dev'] ],
  }

  exec { "make-${version}":
    cwd => "/usr/src/php-${version}",
    command => "make",
    timeout => 0,
    logoutput => 'on_failure',
    require => Exec["configure-${version}"],
  }

  exec { "make-install-${version}":
    cwd => "/usr/src/php-${version}",
    command => "make install",
    timeout => 0,
    logoutput => 'on_failure',
    require => Exec["make-${version}"],
  }
}