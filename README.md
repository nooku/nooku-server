README
======

Building the box
----------------

* Clone this repository at [git://git.assembla.com/nooku-framework.git](git://git.assembla.com/nooku-framework.git)

```
    $ git clone git://git.assembla.com/nooku-framework.git
```

* Switch to the [develop](https://nooku.assembla.com/code/nooku-framework/git/nodes/develop) branch

```
    $ git checkout develop
```

* Install [VirtualBox](http://www.virtualbox.org/)
* Install [Vagrant](http://downloads.vagrantup.com/)
* Run `vagrant up`

```
    $ vagrant up
```

Repackaging the box
-----------------

Run purge.sh to reduce the VM size:

    $ sudo purge.sh

Make sure to remove the Nooku flag: 

    $ rm /nooku-install-run
	
Ensure the nooku database is removed:

    $ mysqladmin -uroot -proot drop nooku
	
Create the package: 

    $ vagrant package --output=nooku.box --vagrantfile Vagrantfile.pkg 

To test the new package locally, remove your current box and setup the local version:

    $ vagrant box remove nooku/box
    $ vagrant box add /path/to/nooku.box --name=nooku/box
	
Go to your [Nooku Framework](https://github.com/nooku/nooku-framework) clone and test: 

    $ cd /path/to/nooku-framework
    $ vagrant destroy # if you've created the box before
    $ vagrant up
	
Share your box using [Vagrant Cloud](http://vagrantcloud.com)!
