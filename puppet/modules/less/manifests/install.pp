class less::install {
  include apt

  apt::ppa { 'ppa:chris-lea/node.js': }

  package { 'nodejs':
    ensure  => present,
    require => Anchor['apt::ppa::ppa:chris-lea/node.js'],
  }

  exec { 'npm-install-less':
    command => 'npm install -g less',
    unless  => 'which lessc',
    require => Package['nodejs'],
  }

  exec { 'npm-install-autoless':
    command => 'npm install -g autoless',
    unless  => 'which autoless',
    require => Package['nodejs'],
  }
}