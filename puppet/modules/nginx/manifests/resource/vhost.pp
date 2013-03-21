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

  $domain = $name

  file { "${nginx::params::conf_dir}/sites-available/${domain}.conf":
    ensure  => file,
    content => template('nginx/vhost.conf.erb'),
    notify  => Class['nginx::service'],
  }

  file { "${nginx::params::conf_dir}/sites-enabled/${domain}.conf":
     ensure  => link,
     target  => "${nginx::params::conf_dir}/sites-available/${domain}.conf",
     notify  => Class['nginx::service'],
     require => File["${nginx::params::conf_dir}/sites-available/${domain}.conf"],
  }

  file { "/var/www/${domain}/public":
    ensure => link,
    target => "/var/www/${domain}/source${public_dir}",
  }

  file { "/var/www/${domain}/private":
    ensure => directory,
  }

  file { "/var/www/${domain}/private/access":
    ensure  => directory,
    require => File["/var/www/${domain}/private"],
  }

  file { "/var/www/${domain}/private/access/index.php":
    ensure  => file,
    content => template('nginx/access.php.erb'),
  }

  file { "/var/www/${domain}/private/error":
    ensure  => directory,
    require => File["/var/www/${name}/private"],
  }

  file { "/var/www/${domain}/private/error/index.php":
    ensure  => file,
    content => template('nginx/error.php.erb'),
  }
}