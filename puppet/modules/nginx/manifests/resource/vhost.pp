define nginx::resource::vhost (
  $public_dir = '/',
) {
  include nginx::params

  $require = Class['nginx::service']

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  file { "${nginx::params::conf_dir}/sites-available/${$name}.conf":
    ensure  => file,
    content => template('nginx/vhost.conf.erb'),
    notify  => Class['nginx::service'],
  }

  file { "${nginx::params::conf_dir}/sites-enabled/${$name}.conf":
     ensure  => link,
     target  => "${nginx::params::conf_dir}/sites-available/${$name}.conf",
     require => File["${nginx::params::conf_dir}/sites-available/${$name}.conf"],
  }

  file { "/var/www/${name}/public":
    ensure => link,
    target => "/var/www/${name}/source${public_dir}",
  }

  file { "/var/www/${name}/private":
    ensure => directory,
  }

  file { "/var/www/${name}/private/access":
    ensure  => directory,
    require => File["/var/www/${name}/private"],
  }

  file { "/var/www/${name}/private/access/index.php":
    ensure  => file,
    content => template('nginx/access.php.erb'),
  }

  file { "/var/www/${name}/private/error":
    ensure  => directory,
    require => File["/var/www/${name}/private"],
  }

  file { "/var/www/${name}/private/error/index.php":
    ensure  => file,
    content => template('nginx/error.php.erb'),
  }
}