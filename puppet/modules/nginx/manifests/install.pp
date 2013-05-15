class nginx::install {
  Exec {
    timeout => 0,
  }

  if ! defined(Package['build-essential']) {
    package { 'build-essential':
      ensure => present,
    }
  }

  if ! defined(Package['zlib1g-dev']) {
    package { 'zlib1g-dev':
      ensure => present,
    }
  }

  if ! defined(Package['libpcre3']) {
    package { 'libpcre3':
      ensure => present,
    }
  }

  if ! defined(Package['libpcre3-dev']) {
    package { 'libpcre3-dev':
      ensure => present,
    }
  }

  exec { 'nginx-download-pagespeed':
    cwd     => '/tmp',
    command => 'wget https://github.com/pagespeed/ngx_pagespeed/archive/release-1.5.27.2-beta.zip',
    require => Package['build-essential', 'zlib1g-dev', 'libpcre3', 'libpcre3-dev'],
  }

  exec { 'nginx-extract-pagespeed':
    cwd     => '/tmp',
    command => 'unzip release-1.5.27.2-beta.zip',
    require => Exec['nginx-download-pagespeed'],
  }

  exec { 'nginx-download-psol':
    cwd     => '/tmp/ngx_pagespeed-release-1.5.27.2-beta/',
    command => 'wget https://dl.google.com/dl/page-speed/psol/1.5.27.2.tar.gz',
    require => Exec['nginx-extract-pagespeed'],
  }

  exec { 'nginx-extract-psol':
    cwd     => '/tmp/ngx_pagespeed-release-1.5.27.2-beta/',
    command => 'tar -xzvf 1.5.27.2.tar.gz',
    require => Exec['nginx-download-psol'],
  }

  exec { 'nginx-download-nginx':
    cwd     => '/tmp',
    command => 'wget http://nginx.org/download/nginx-1.4.1.tar.gz',
    require => Exec['nginx-extract-psol'],
  }

  exec { 'nginx-extract-nginx':
    cwd     => '/tmp',
    command => 'tar -xvzf nginx-1.4.1.tar.gz',
    require => Exec['nginx-download-nginx'],
  }

  exec { 'nginx-configure-nginx':
    cwd     => '/tmp/nginx-1.4.1/',
    path    => [ '/tmp/nginx-1.4.1/', '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ],
    command => './configure --add-module=/tmp/ngx_pagespeed-release-1.5.27.2-beta',
    require => Exec['nginx-extract-nginx'],
  }

  exec { 'nginx-make-nginx':
    cwd     => '/tmp/nginx-1.4.1/',
    command => 'make',
    require => Exec['nginx-configure-nginx'],
  }

  exec { 'nginx-make-install-nginx':
    cwd     => '/tmp/nginx-1.4.1/',
    command => 'make install',
    require => Exec['nginx-make-nginx'],
  }
}