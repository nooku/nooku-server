class nginx::config {
  include nginx::params

  $require = Class['nginx::install']

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  file { "${nginx::params::conf_dir}":
    ensure => directory,
  }

  file { "${nginx::params::conf_dir}/conf.d":
    ensure  => directory,
    require => File["${nginx::params::conf_dir}"],
  }

  file { "${nginx::params::conf_dir}/sites-available":
    ensure  => directory,
    require => File["${nginx::params::conf_dir}"],
  }

  file { "${nginx::params::conf_dir}/sites-enabled":
    ensure  => directory,
    require => File["${nginx::params::conf_dir}"],
  }

  file { "${nginx::params::conf_dir}/nginx.conf":
    ensure  => file,
    content => template('nginx/nginx.conf.erb'),
    notify  => Class['nginx::service'],
    require => File["${nginx::params::conf_dir}"],
  }

  file { "${nginx::params::conf_dir}/nooku.inc":
    ensure  => file,
    content => template('nginx/nooku.inc.erb'),
    notify  => Class['nginx::service'],
    require => File["${nginx::params::conf_dir}"],
  }
}