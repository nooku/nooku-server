class php::config {
  $require = Anchor['php::install']

  include php::config::php_53
  include php::config::php_54

  file { '/var/run/php-fpm/':
    ensure => directory,
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0644',
  }

  anchor { 'php::config':
    require => [ Anchor['php::config::php_53', 'php::config::php_54'], File['/var/run/php-fpm/'] ]
  }
}