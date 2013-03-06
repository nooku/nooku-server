class php::service {
  $require = Class['php::config']

  service { ['php53-fpm', 'php54-fpm']:
    ensure     => running,
    hasstatus  => false,
    hasrestart => true,
    enable     => false,
    require    => $require,
  }
}