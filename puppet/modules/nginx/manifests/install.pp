class nginx::install {
  include apt

  File {
    owner => 'root',
    group => 'root',
    mode  => '0755',
  }

  apt::source { 'nginx':
    location   => 'http://nginx.org/packages/ubuntu/',
    repos      => 'nginx',
    key        => '7BD9BF62',
    key_source => 'http://nginx.org/keys/nginx_signing.key',
  }

  package { 'nginx':
    ensure  => present,
    require => Anchor['apt::source::nginx'],
  }

  package { 'spawn-fcgi':
    ensure => present,
  }

  file { '/usr/bin/php-fastcgi-5.3':
    ensure => file,
    source => 'puppet:///modules/nginx/usr/bin/php-fastcgi-5.3',
  }

  file { '/usr/bin/php-fastcgi-5.4':
    ensure => file,
    source => 'puppet:///modules/nginx/usr/bin/php-fastcgi-5.4',
  }

  file { '/etc/init.d/php-fastcgi-5.3':
    ensure => file,
    source => 'puppet:///modules/nginx/etc/init.d/php-fastcgi-5.3',
  }

  file { '/etc/init.d/php-fastcgi-5.4':
    ensure => file,
    source => 'puppet:///modules/nginx/etc/init.d/php-fastcgi-5.4',
  }

  file { '/var/run/php-fastcgi':
    ensure => directory,
    owner  => 'www-data',
    group  => 'www-data',
  }
}