class nginx::webgrind {
  include nginx::params

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  $domain = 'webgrind.nooku.vagrant'

  file { "${nginx::params::conf_dir}/sites-available/${domain}.conf":
    ensure  => file,
    content => template('nginx/webgrind.conf.erb'),
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
    target => "/var/www/${domain}/source",
  }
}