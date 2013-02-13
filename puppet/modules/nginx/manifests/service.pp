class nginx::service {
  $require = Class['nginx::config']

  service { 'nginx':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    enable     => true,
    require    => Class['nginx::install']
  }
}