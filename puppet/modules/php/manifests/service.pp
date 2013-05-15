class php::service {
  $require = Anchor['php::config']

  service { ['php-fpm-5.3', 'php-fpm-5.4']:
    ensure     => running,
    hasstatus  => false,
    hasrestart => true,
    enable     => false,
    require    => $require,
  }
}