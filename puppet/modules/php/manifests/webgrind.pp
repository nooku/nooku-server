class php::webgrind {
  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  $domain = 'webgrind.nooku.dev'

  exec { 'php-download-webgrind':
    cwd     => '/tmp',
    command => 'wget https://webgrind.googlecode.com/files/webgrind-release-1.0.zip',
  }

  exec { 'php-extract-webgrind':
    cwd     => '/tmp',
    command => 'unzip webgrind-release-1.0.zip',
    require => Exec['php-download-webgrind'],
  }

  file { "/var/www/${domain}":
    ensure => directory,
  }

  file { "/var/www/${domain}/source":
    ensure => directory,
  }

  exec { 'php-move-webgrind':
    command => "cp -r /tmp/webgrind/* /var/www/${domain}/source/",
    creates => "/var/www/${domain}/source/index.php",
    require => [ Exec['php-extract-webgrind'], File['/var/www/webgrind.nooku.dev/source'] ],
  }
}