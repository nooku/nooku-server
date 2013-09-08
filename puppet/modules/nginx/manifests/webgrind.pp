class nginx::webgrind {
  include nginx::params

  $require = Class['nginx::config']

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  $domain = 'webgrind.nooku.vagrant'

  file { "${nginx::params::conf_dir}/sites-available/${domain}.conf":
    ensure  => file,
    content => template('nginx/webgrind.conf.erb'),
    require => $require,
    notify  => Class['nginx::service'],
  }

  file { "${nginx::params::conf_dir}/sites-enabled/${domain}.conf":
     ensure  => link,
     target  => "${nginx::params::conf_dir}/sites-available/${domain}.conf",
     notify  => Class['nginx::service'],
     require => File["${nginx::params::conf_dir}/sites-available/${domain}.conf"],
  }

  file { "/var/www/${domain}":
    ensure => directory,
  }

  file { "/var/www/${domain}/source":
    ensure => directory,
  }

  file { "/var/www/${domain}/public":
    ensure  => link,
    target  => "/var/www/${domain}/source",
    require => File["/var/www/${domain}/source"]
  }
}