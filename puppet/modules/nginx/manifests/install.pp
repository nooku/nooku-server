class nginx::install {
  apt::source { 'nginx':
    location   => 'http://nginx.org/packages/ubuntu/',
    repos      => 'nginx',
    key        => '7BD9BF62',
    key_source => 'http://nginx.org/keys/nginx_signing.key',
  }

  package { 'nginx':
    ensure => present,
    require => Anchor['apt::source::nginx'],
  }
}