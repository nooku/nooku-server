class varnish {

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

  service {'varnish':
    ensure  => running,
    restart => 'service varnish restart',
    require => Package['varnish']
  }

  file { '/etc/default/varnish':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => "puppet:///modules/varnish/varnish.conf",
    require => Package['varnish'],
    notify  => Service['varnish']
  }

  file { '/etc/varnish/default.vcl':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => "puppet:///modules/varnish/nooku.vcl",
    require => Package['varnish'],
    notify  => Service['varnish']
  }
}