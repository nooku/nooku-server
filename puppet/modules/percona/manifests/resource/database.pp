define percona::resource::database() {
  $require = Class['percona::service']

  exec { "drop-database-${name}":
    command => "mysql --user='root' --password='root' --execute 'DROP DATABASE IF EXISTS `${name}`;'",
    require => $require,
  }

  exec { "create-database-${name}":
    command => "mysql --user='root' --password='root' --execute 'CREATE DATABASE `${name}`;'",
    require => Exec["drop-database-${name}"],
  }
}