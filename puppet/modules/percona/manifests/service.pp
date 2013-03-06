class percona::service {
  $require = Class['percona::config']

  service { 'mysql':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    enable     => true,
    require    => $require,
  }
}