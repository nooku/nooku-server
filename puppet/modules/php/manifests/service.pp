class php::service {
  $require = Class['php::config']

  service { ['php53-fpm', 'php54-fpm']:
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    enable     => true,
    require    => Class['nginx::install'],
  }
}