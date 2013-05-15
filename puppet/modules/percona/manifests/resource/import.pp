define percona::resource::import(
  $database = undef,
  $file     = undef,
) {
  exec { "import-sql-${name}":
    command => "mysql --user='root' --password='root' '${database}' < '${file}'",
    timeout => 0,
    require => Exec["create-database-${database}"],
  }
}