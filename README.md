README
======

Building the box
----------------

* Clone this repository from [https://github.com/nooku/nooku-server.git](https://github.com/nooku/nooku-server.git)

```
    $ git clone https://github.com/nooku/nooku-server.git
    $ cd nooku-server
```

* Install [VirtualBox](http://www.virtualbox.org/)
* Install [Vagrant](http://www.vagrantup.com/)
* Run `vagrant up`

```
    $ vagrant up
```

Repackaging the box
-----------------

Run purge.sh to reduce the VM size:

    $ sudo purge.sh

Make sure to remove all flags which should not be set by default: 

    $ rm /nooku-install-run /var/www/default/varnish-enabled
	
Ensure the nooku database is removed:

    $ mysqladmin -uroot -proot drop nooku
	
Create the package: 

    $ vagrant package --output=nooku.box --vagrantfile Vagrantfile.pkg 

To test the new package locally, remove your current box and setup the local version:

    $ vagrant box remove nooku/box
    $ vagrant box add /path/to/nooku.box --name=nooku/box
	
Go to your [Nooku Platform](https://github.com/nooku/nooku-platform) clone and test: 

    $ cd /path/to/nooku-platform
    $ vagrant destroy # if you've created the box before
    $ vagrant up
	
Share your box using [Vagrant Cloud](http://vagrantcloud.com)!
