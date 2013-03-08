Exec {
  path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ],
}

stage { 'first':
  before => Stage['main'],
}

class { 'ubuntu':
  stage => 'first',
}

node server {
  include nginx
  include php
  include percona
  include git
  include subversion
  include zip
  include vim
  include less
}

import 'nodes/*'