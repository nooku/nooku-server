class nginx::service {
  $require = [ Class['nginx::install'], Class['nginx::config'] ]

  service { 'nginx':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    enable     => true,
    require    => $require,
  }

  service { 'php-fastcgi-5.3':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    enable     => true,
    require    => $require,
  }

  service { 'php-fastcgi-5.4':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    enable     => true,
    require    => $require,
  }
}