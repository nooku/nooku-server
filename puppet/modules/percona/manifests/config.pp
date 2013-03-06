class percona::config {
  $require = Class['percona::install']

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  file { '/etc/mysql/my.cnf':
    ensure  => file,
    content => template('percona/my.cnf.erb'),
    notify  => Class['percona::service'],
    require => $require,
  }

  exec { 'set-mysql-root-password':
    command   => "mysqladmin -u'root' password 'root'",
    logoutput => on_failure,
    unless    => "which mysqladmin && mysqladmin --user='root' -password='root' status > /dev/null",
    notify    => Class['percona::service'],
    require   => $require
  }

  exec { 'grant-all-to-root':
    command   => "mysql --user='root' --password='root' --execute=\"GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION;\"",
    logoutput => on_failure,
    notify    => Class['percona::service'],
    require   => Exec['set-mysql-root-password'],
  }
}