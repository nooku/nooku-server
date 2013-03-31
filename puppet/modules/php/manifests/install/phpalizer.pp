class php::install::phpalizer {
  $require = Class['php::install::composer']

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  exec { 'php-install-phpalizer':
    cwd     => '/opt',
    command => 'composer create-project scrutinizer/php-analyzer:dev-master',
    timeout => 0,
    creates => '/opt/php-analyzer',
    require => $require,
  }

  file { '/usr/bin/phpalizer':
    ensure  => link,
    target  => '/opt/php-analyzer/bin/phpalizer',
    require => Exec['php-install-phpalizer'],
  }
}