class nginx::config {
  include nginx::params

  $require = Class['nginx::install']

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  file { "${nginx::params::conf_dir}":
    ensure  => directory,
    require => $require,
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

  file { "${nginx::params::conf_dir}/fastcgi_params":
    ensure  => file,
    source  => 'puppet:///modules/nginx/etc/nginx/fastcgi_params',
    require => File["${nginx::params::conf_dir}"],
  }

  file { "${nginx::params::conf_dir}/koi-utf":
    ensure  => file,
    source  => 'puppet:///modules/nginx/etc/nginx/koi-utf',
    require => File["${nginx::params::conf_dir}"],
  }

  file { "${nginx::params::conf_dir}/koi-win":
    ensure  => file,
    source  => 'puppet:///modules/nginx/etc/nginx/koi-win',
    require => File["${nginx::params::conf_dir}"],
  }

  file { "${nginx::params::conf_dir}/mime.types":
    ensure  => file,
    source  => 'puppet:///modules/nginx/etc/nginx/mime.types',
    require => File["${nginx::params::conf_dir}"],
  }

  file { "${nginx::params::conf_dir}/scgi_params":
    ensure  => file,
    source  => 'puppet:///modules/nginx/etc/nginx/scgi_params',
    require => File["${nginx::params::conf_dir}"],
  }

  file { "${nginx::params::conf_dir}/uwsgi_params":
    ensure  => file,
    source  => 'puppet:///modules/nginx/etc/nginx/uwsgi_params',
    require => File["${nginx::params::conf_dir}"],
  }

  file { "${nginx::params::conf_dir}/win-utf":
    ensure  => file,
    source  => 'puppet:///modules/nginx/etc/nginx/win-utf',
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

  file { '/etc/init.d/nginx':
    ensure  => file,
    mode    => '0755',
    source  => 'puppet:///modules/nginx/etc/init.d/nginx',
  }

  file { '/var/log/nginx':
    ensure => directory,
    mode   => '0755',
  }
}