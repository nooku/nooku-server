define less::resource::watcher(
  $source      = undef,
  $destination = undef,
) {
  $require = Class['less::install']

  exec { "watch-${name}":
    command   => "autoless '${source}' '${destination}' &",
    logoutput => on_failure,
    require   => $require,
  }
}