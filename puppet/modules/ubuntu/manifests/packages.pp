class ubuntu::packages {
  @package { 'curl':
    ensure => present,
  }

  @package { 'git':
    ensure => present,
  }

  @package { 'subversion':
    ensure => present,
  }

  @package { 'zip':
    ensure => present,
  }

  @package { 'unzip':
    ensure => present,
  }

  @package { 'vim':
    ensure => present,
  }
}