class php::install::phpalizer {
  $require = Anchor['php::install::composer']

  Exec {
    timeout => 0,
  }

  File {
    owner => 'root',
    group => 'root',
    mode  => '0755',
  }

  exec { 'php-install-phpalizer':
    cwd     => '/usr/local',
    command => 'composer create-project scrutinizer/php-analyzer:dev-master',
    creates => '/usr/local/php-analyzer',
    require => $require,
  }

  file { '/usr/bin/phpalizer':
    ensure  => link,
    target  => '/usr/local/php-analyzer/bin/phpalizer',
    require => Exec['php-install-phpalizer'],
  }

  anchor { 'php::install::phpalizer':
    require => File['/usr/bin/phpalizer'],
  }
}