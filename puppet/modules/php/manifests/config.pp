class php::config {
  define php::config::source {
    $require = Class['php::install']

    File {
      owner => 'root',
      group => 'root',
      mode  => '0644',
    }

    $version = $name

    case $version {
      '5.3': {
        include php::params::53

        $short_version = '53'
        $conf_dir      = $php::params::53::conf_dir
      }
      '5.4': {
        include php::params::54

        $short_version = '54'
        $conf_dir      = $php::params::54::conf_dir
      }
    }

    file { "${conf_dir}":
      ensure  => directory,
      require => $require,
    }

    file { "${conf_dir}/conf.d":
      ensure  => directory,
      require => File["${conf_dir}"],
    }

    file { "${conf_dir}/php.ini":
      ensure  => file,
      content => template("php/${version}/php.ini.erb"),
      notify  => Class['php::service'],
      require => File["${conf_dir}"],
    }

    file { "${conf_dir}/php-fpm.conf.default":
      ensure  => absent,
      require => File["${conf_dir}"],
    }

    file { "${conf_dir}/php-fpm.conf":
      ensure  => file,
      content => template("php/${version}/php-fpm.conf.erb"),
      notify  => Class['php::service'],
      require => File["${conf_dir}"],
    }

    file { "${conf_dir}/conf.d/xdebug.ini":
      ensure  => file,
      content => template("php/${version}/xdebug.ini.erb"),
      notify  => Class['php::service'],
      require => File["${conf_dir}/conf.d"],
    }

    file { "${conf_dir}/conf.d/yaml.ini":
      ensure  => file,
      content => template("php/${version}/yaml.ini.erb"),
      notify  => Class['php::service'],
      require => File["${conf_dir}/conf.d"],
    }

    file { "/etc/init.d/php${short_version}-fpm":
      ensure  => file,
      content => template("php/${version}/php-fpm.init.erb"),
      mode    => 0744,
      notify  => Class['php::service'],
      require => $require,
    }
  }

  php::config::source { '5.3': }
  php::config::source { '5.4': }
}