class scripts {
  class {"scripts::install": }
}

class scripts::install {
  file { '/home/vagrant/scripts':
    source => 'puppet:///modules/scripts/scripts',
    recurse => true,
    owner    => vagrant,
    group    => vagrant,
  }
  
  exec { 'make-scripts-executable': 
    command => 'chmod +x /home/vagrant/scripts/nooku',
    require => File['/home/vagrant/scripts']
  }

  exec { 'add-scripts-to-path':
    command => 'echo "export PATH=\$PATH:/home/vagrant/scripts" >> /home/vagrant/.profile',
    unless  => 'grep ":/home/vagrant/scripts" /home/vagrant/.profile',
    require => Exec['make-scripts-executable']
  }
}