class percona::install {
  include apt

  apt::source { 'percona':
    location   => 'http://repo.percona.com/apt',
    key        => '1C4CBDCDCD2EFD2A',
    key_server => 'keys.gnupg.net',
  }

  package { ['percona-server-server-5.5', 'percona-server-client-5.5']:
    ensure  => present,
    require => Anchor['apt::source::percona'],
  }
}