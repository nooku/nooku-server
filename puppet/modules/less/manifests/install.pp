class less::install {
  apt::ppa { 'ppa:richarvey/nodejs': }

  if ! defined(Package['npm']) {
    package { 'npm':
      ensure  => present,
      require => Anchor['apt::ppa::ppa:richarvey/nodejs'],
    }
  }

  exec { 'npm-install-less':
    command   => 'npm install -g less',
    unless    => 'which lessc',
    logoutput => on_failure,
    require   => Package['npm'],
  }

  exec { 'npm-install-autoless':
    command   => 'npm install -g autoless',
    unless    => 'which autoless',
    logoutput => on_failure,
    require   => Package['npm'],
  }
}