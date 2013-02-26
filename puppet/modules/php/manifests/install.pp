class php::install {
  include apt

  apt::ppa { 'ppa:skettler/php': }

  package { [ 'php53', 'php53-apc' ]:
    ensure  => present,
    require => Anchor['apt::ppa::ppa:skettler/php'],
  }

  package { [ 'php54', 'php54-apc' ]:
    ensure  => present,
    require => Anchor['apt::ppa::ppa:skettler/php'],
  }
}