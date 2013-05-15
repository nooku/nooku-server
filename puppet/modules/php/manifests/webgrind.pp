class php::webgrind {
  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  $domain = 'webgrind.nooku.vagrant'

  exec { 'php-download-webgrind':
    cwd     => '/tmp',
    command => 'wget https://webgrind.googlecode.com/files/webgrind-release-1.0.zip',
    creates => "/var/www/${domain}/source/index.php",
  }

  exec { 'php-extract-webgrind':
    cwd     => '/tmp',
    command => 'unzip webgrind-release-1.0.zip',
    creates => "/var/www/${domain}/source/index.php",
    require => Exec['php-download-webgrind'],
  }

  exec { 'php-move-webgrind':
    command => "cp -r /tmp/webgrind/* /var/www/${domain}/source/",
    creates => "/var/www/${domain}/source/index.php",
    require => [ Exec['php-extract-webgrind'], File['/var/www/webgrind.nooku.vagrant/source'] ],
  }
}