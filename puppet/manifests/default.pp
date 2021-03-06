group { 'puppet': ensure => present }
Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }
File { owner => 0, group => 0, mode => 0644, backup => true }

class {'apt':
  always_apt_update => true,
}

Class['::apt::update'] -> Package <|
    title != 'python-software-properties'
and title != 'software-properties-common'
|>

apt::key { '4F4EA0AAE5267A6C': }

apt::ppa { 'ppa:ondrej/php5-oldstable':
  require => Apt::Key['4F4EA0AAE5267A6C']
}

apt::key { 'nginx':
  key     => 'FA4657A64602F602'
}

apt::ppa { 'ppa:adegtyarev/nginx-pagespeed':
  require => Apt::Key['nginx']
}

apt::source { 'mariadb':
  location => 'http://mariadb.cu.be//repo/5.5/ubuntu',
  key      => 'cbcb082a1bb943db',
}
    
class { 'puphpet::dotfiles': }

package { [
    'build-essential',
    'vim',
    'curl',
    'git-core',
    'unzip'
  ]:
  ensure  => 'installed',
}

file { '/var/www/':
  ensure => directory,
  mode   => '0644',
  group  => 'root',
  owner  => 'root'
}

file { '/var/www/default':
  ensure => directory,
  mode   => '0644',
  group  => 'www-data',
  owner  => 'www-data',
  require => File['/var/www']
}

file { '/var/cache/nginx':
  ensure => directory,
  mode   => '0644',
  group  => 'root',
  owner  => 'root'
}

file { '/var/cache/nginx/pagespeed':
  ensure => directory,
  mode   => '0644',
  group  => 'root',
  owner  => 'root',
  require => File['/var/cache/nginx']
}

class { 'nginx':
  require => File['/var/cache/nginx/pagespeed']
}

class {'varnish': }

file { "${nginx::config::nx_temp_dir}/nginx.d/nooku-001":
  ensure  => file,
  content => template('nginx/vhost/nooku.erb'),
  notify  => Class['nginx::service'],
}

class { 'php':
  package             => 'php5-fpm',
  service             => 'php5-fpm',
  service_autorestart => false,
  config_file         => '/etc/php5/fpm/php.ini',
  module_prefix       => ''
}

php::module {
  [
    'php5-mysql',
    'php5-cli',
    'php5-curl',
    'php5-gd',
    'php5-intl',
    'php5-mcrypt',
    'php-apc',
  ]:
  service => 'php5-fpm',
}

service { 'php5-fpm':
  ensure     => running,
  enable     => true,
  hasrestart => true,
  hasstatus  => true,
  require    => Package['php5-fpm'],
}

class { 'php::devel':
  require => Class['php'],
}

file { '/etc/php5/fpm/pool.d/www.conf':
  source  => 'puppet:///modules/php/www.conf',
  require => Class['php'],
  notify  => Service['php5-fpm']
}

class { 'php::pear': }

php::pear::config {
  download_dir: value => "/tmp/pear/download",
  require => Class['php::pear']
}

php::pear::module { 'Console_CommandLine':
  use_package => false
}

php::pear::module { 'Phing':
  use_package => false,
  repository  => 'pear.phing.info'
}

package { 'libyaml-dev':
  ensure => present,
}

php::pecl::module { 'yaml':
  use_package => no,
  ensure => present,
  require => [php::pear::config['download_dir'], Package['libyaml-dev']]
}

puphpet::ini { 'yaml':
  value   => [
    'extension=yaml.so'
  ],
  ini     => '/etc/php5/conf.d/zzz_yaml.ini',
  notify  => Service['php5-fpm'],
  require => [Class['php'], php::pecl::module['yaml']],
}

class { 'xdebug':
  service => 'nginx',
}

# Install Xdebug but disable it by default since it's super slow
file { '/etc/php5/cli/conf.d/20-xdebug.ini':
  ensure => absent,
  notify  => Service['php5-fpm'],
  require => [Class['nginx'], Class['php']],
}

class { 'composer':
  require => Package['php5-fpm', 'curl'],
}

puphpet::ini { 'php':
  value   => [
    'date.timezone = "UTC"'
  ],
  ini     => '/etc/php5/conf.d/zzz_php.ini',
  notify  => Service['php5-fpm'],
  require => Class['php'],
}

puphpet::ini { 'custom':
  value   => [
    'sendmail_path = /opt/vagrant_ruby/bin/catchmail -fnoreply@example.com',
    'display_errors = On',
    'error_reporting = E_ALL & ~E_STRICT',
    'upload_max_filesize = "256M"',
    'post_max_size = "256M"',
    'memory_limit = "128M"'
  ],
  ini     => '/etc/php5/conf.d/zzz_custom.ini',
  notify  => Service['php5-fpm'],
  require => Class['php'],
}

# For enabling xdebug support for php-fpm, just uncomment the zend_extension directive and re-provision the VM.
puphpet::ini { 'xdebug':
  value   => [
  ';zend_extension=/usr/lib/php5/20100525/xdebug.so',
  'xdebug.remote_autostart = 0',
  'xdebug.remote_connect_back = 1',
  'xdebug.remote_enable = 1',
  'xdebug.remote_handler = "dbgp"',
  'xdebug.remote_port = 9000',
  'xdebug.remote_host = "33.33.33.1"',
  'xdebug.show_local_vars = 0',
  'xdebug.profiler_enable = 0',
  'xdebug.profiler_enable_trigger = 1',
  'xdebug.max_nesting_level = 1000'
  ],
  ini     => '/etc/php5/conf.d/zzz_xdebug.ini',
  notify  => Service['php5-fpm'],
  require => Class['php'],
}

class { 'mysql::server':
  config_hash   => {
    'root_password' => 'root',
    'bind_address' => false,
  },
  package_name => 'mariadb-server'
}

exec { 'grant-all-to-root':
  command     => "mysql --user='root' --password='root' --execute=\"GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION;\"",
  require => Class['phpmyadmin']
}

class { 'phpmyadmin':
  require => [Class['mysql::server'], Class['mysql::config'], Class['php']],
}

nginx::resource::vhost { 'phpmyadmin.nooku.dev':
  ensure      => present,
  server_name => ['phpmyadmin.nooku.dev'],
  listen_port => 8080,
  index_files => ['index.php'],
  www_root    => '/usr/share/phpmyadmin',
  try_files   => ['$uri', '$uri/', '/index.php?$args'],
  require     => Class['phpmyadmin'],
}

nginx::resource::location { "phpmyadmin-php":
  ensure              => 'present',
  vhost               => 'phpmyadmin.nooku.dev',
  location            => '~ \.php$',
  proxy               => undef,
  try_files           => ['$uri', '$uri/', '/index.php?$args'],
  www_root            => '/usr/share/phpmyadmin',
  location_cfg_append => {
    'fastcgi_split_path_info' => '^(.+\.php)(/.+)$',
    'fastcgi_param'           => 'PATH_INFO $fastcgi_path_info',
    'fastcgi_param '          => 'PATH_TRANSLATED $document_root$fastcgi_path_info',
    'fastcgi_param  '         => 'SCRIPT_FILENAME $document_root$fastcgi_script_name',
    'fastcgi_pass'            => 'unix:/var/run/php5-fpm.sock',
    'fastcgi_index'           => 'index.php',
    'include'                 => 'fastcgi_params'
  },
  notify              => Class['nginx::service'],
  require             => Nginx::Resource::Vhost['phpmyadmin.nooku.dev'],
}

nginx::resource::vhost { 'default':
  ensure      => present,
  server_name => ['localhost'],
  listen_port => 8080,
  listen_options => 'default',
  index_files => ['index.php', 'index.html'],
  www_root    => '/var/www/default',
  require     => File['/var/www/default']
}

nginx::resource::location { 'varnish-enabled':
  ensure              => 'present',
  vhost               => 'default',
  location            => '= /varnish-enabled',
  www_root            => '/var/www/default',
  location_cfg_append => {
    'error_log'  => '/dev/null',
    'access_log' => 'off'
  },
  notify              => Class['nginx::service'],
  require             => Nginx::Resource::Vhost['default'],
}

exec { 'nginx-include-fastcgi-environment':
  command => "touch /etc/nginx/fastcgi_environment && echo \"\ninclude  fastcgi_environment;\" >> /etc/nginx/fastcgi_params",
  unless  => "grep fastcgi_environment /etc/nginx/fastcgi_params",
  notify  => Class['nginx::service'],
  require => File["${nginx::config::nx_temp_dir}/nginx.d/nooku-001"]
}

exec { 'gem-i18n-legacy':
  command => '/opt/vagrant_ruby/bin/gem install i18n -v=0.6.5',
  unless  => 'test `/opt/vagrant_ruby/bin/gem list --local | grep -q 0.6.5; echo $?` -eq 0',
  path    => ['/usr/bin', '/bin'],
}

class { 'mailcatcher':
  require => Exec['gem-i18n-legacy']
}

class { 'less': }

class { 'uglifyjs': }

class { 'scripts': }

class { 'webgrind':
  require => Package['unzip'],
}

nginx::resource::vhost { 'webgrind.nooku.dev':
  ensure      => present,
  server_name => ['webgrind.nooku.dev'],
  listen_port => 8080,
  index_files => ['index.php'],
  www_root    => '/usr/share/webgrind',
  try_files   => ['$uri', '$uri/', '/index.php?$args'],
  require     => Class['webgrind'],
}

nginx::resource::location { "webgrind-php":
  ensure              => 'present',
  vhost               => 'webgrind.nooku.dev',
  location            => '~ \.php$',
  proxy               => undef,
  try_files           => ['$uri', '$uri/', '/index.php?$args'],
  www_root            => '/usr/share/webgrind',
  location_cfg_append => {
  'fastcgi_split_path_info' => '^(.+\.php)(/.+)$',
  'fastcgi_param'           => 'PATH_INFO $fastcgi_path_info',
  'fastcgi_param '          => 'PATH_TRANSLATED $document_root$fastcgi_path_info',
  'fastcgi_param  '         => 'SCRIPT_FILENAME $document_root$fastcgi_script_name',
  'fastcgi_pass'            => 'unix:/var/run/php5-fpm.sock',
  'fastcgi_index'           => 'index.php',
  'include'                 => 'fastcgi_params'
  },
  notify              => Class['nginx::service'],
  require             => Nginx::Resource::Vhost['webgrind.nooku.dev'],
}