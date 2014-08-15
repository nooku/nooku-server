class varnish::install {

  apt::source { 'varnish':
    location   => "http://repo.varnish-cache.org/ubuntu",
    repos      => "varnish-4.0",
    key        => 'C4DEFFEB',
    key_source => 'http://repo.varnish-cache.org/debian/GPG-key.txt',
  }

  package { 'varnish':
    ensure  => 'latest',
    require => Apt::Source['varnish']
  }

}