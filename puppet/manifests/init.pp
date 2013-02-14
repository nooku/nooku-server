Exec {
  path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ]
}

Package {
  require => Exec['apt_update']
}

import 'nodes/*'

node server {
  include nginx
  include php
}