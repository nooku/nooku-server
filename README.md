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

SSH into the vagrant box

   $ vagrant ssh

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

You will also need to comment out/remove the version requirement from the project's Vagrantfile in order to test the box

    config.vm.box_version = "3.1.0" -> #config.vm.box_version = "3.1.0"

Then start your vagrant box:

    $ vagrant up
	
Share your box using [Vagrant Cloud](http://vagrantcloud.com)!

## Contributing

Nooku Server is an open source, community-driven project. Contributions are welcome from everyone. 
We have [contributing guidelines](CONTRIBUTING.md) to help you get started.

## Contributors

See the list of [contributors](https://github.com/nooku/nooku-server/contributors).

## License 

Nooku Server is free and open-source software licensed under the [GPLv3 license](LICENSE.txt).

## Community

Keep track of development and community news.

* Follow [@joomlatoolsdev on Twitter](https://twitter.com/joomlatoolsdev)
* Join [joomlatools/dev on Gitter](http://gitter.im/joomlatools/dev)
* Read the [Joomlatools Developer Blog](https://www.joomlatools.com/developer/blog/)
* Subscribe to the [Joomlatools Developer Newsletter](https://www.joomlatools.com/developer/newsletter/)
