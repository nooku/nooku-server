define php::install::source(
  $packages = undef,
) {
  include php::params

  $version = $name
  $url     = "http://www.php.net/get/php-${version}.tar.gz/from/this/mirror"

  case $version {
    /^5\.3/: {
      $short_version = '53'
      $configure     = $php::params::configure_53
      $xdebug        = $php::params::xdebug_53
    }
    /^5\.4/: {
      $short_version = '54'
      $configure     = $php::params::configure_54
      $xdebug        = $php::params::xdebug_54
    }
  }

  exec { "download-${version}":
    cwd       => '/tmp',
    command   => "wget -O php-${version}.tar.gz ${url}",
    creates   => "/usr/local/php${short_version}/bin/php",
    timeout   => 3600,
    logoutput => 'on_failure',
  }

  exec { "extract-${version}":
    cwd       => '/tmp',
    command   => "tar xzvpf php-${version}.tar.gz -C /usr/src",
    creates   => "/usr/local/php${short_version}/bin/php",
    logoutput => on_failure,
    require   => Exec["download-${version}"],
  }

  exec { "configure-${version}":
    cwd       => "/usr/src/php-${version}",
    command   => "configure $configure",
    creates   => "/usr/local/php${short_version}/bin/php",
    path      => [ "/usr/src/php-${version}", '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ],
    timeout   => 0,
    logoutput => on_failure,
    require   => [ Exec["extract-${version}"], Package[$packages]],
  }

  exec { "make-${version}":
    cwd       => "/usr/src/php-${version}",
    command   => "make",
    creates   => "/usr/local/php${short_version}/bin/php",
    timeout   => 0,
    logoutput => on_failure,
    require   => Exec["configure-${version}"],
  }

  exec { "make-install-${version}":
    cwd       => "/usr/src/php-${version}",
    command   => "make install",
    creates   => "/usr/local/php${short_version}/bin/php",
    timeout   => 0,
    logoutput => on_failure,
    require   => Exec["make-${version}"],
  }

  exec { "install-xdebug-${version}":
    cwd       => "/usr/local/php${short_version}/bin",
    command   => 'pecl install xdebug',
    path      => [ "/usr/local/php${short_version}/bin", '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ],
    creates   => $xdebug,
    timeout   => 0,
    logoutput => on_failure,
    require   => Exec["make-install-${version}"],
  }

  anchor { "php::install::source::${name}":
    require => Exec["make-install-${version}"],
  }
}