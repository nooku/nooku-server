class php::config {
  $require = Class['php::install']

  define php::config::source {
    File {
      owner => 'root',
      group => 'root',
      mode  => '0644',
    }

    $version = $name
    $short_version = regsubst($version, '\.', '')

    $conf_dir = $version ? {
      '5.3' => $php::params::conf_dir_53,
      '5.4' => $php::params::conf_dir_54,
    }

    file { "${conf_dir}":
      ensure  => directory,
      require => $require,
    }

    file { "${conf_dir}/php.ini":
      ensure  => 'file',
      content => template("php/${version}/php.ini.erb"),
      notify  => Class['php::service'],
      require => File["${conf_dir}"],
    }

    file { "${conf_dir}/php-fpm.conf.default":
      ensure  => absent,
      require => File["${conf_dir}"],
    }

    file { "${conf_dir}/php-fpm.conf":
      ensure  => 'file',
      content => template("php/${version}/php-fpm.conf.erb"),
      notify  => Class['php::service'],
      require => File["${conf_dir}"],
    }

    file { "/etc/init.d/php${short_version}-fpm":
      ensure  => 'file',
      content => template("php/${version}/php-fpm.init.erb"),
      mode    => 0744,
      notify  => Class['php::service'],
      require => $require,
    }
  }

  php::config::source { '5.3': }
  php::config::source { '5.4': }
}