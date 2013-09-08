Exec {
  path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ],
}

stage { 'first':
  before => Stage['main'],
}

class { 'ubuntu':
  stage => 'first',
}

import 'nodes/*'