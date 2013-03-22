Vagrant uses Oracle’s VirtualBox to build configurable, lightweight, and portable virtual machines dynamically.

# Installation

1. Download and install [VirtualBox](https://www.virtualbox.org/wiki/Downloads). Nothing else needs to be done, you even don't need to open it after install, Vagrant uses the command line interface of VirtualBox.

2. Download and install [Vagrant](http://docs.vagrantup.com/v2/installation/index.html).

# Configuration

The Vagrant box uses a YAML configuration file to create hosts. A sample configuration file can be found in `config/config.yaml.example`:


    ---
    nooku.vagrant: # required
      dir: ~/Workspace/nooku-framework
      sql:
        nooku: [ install/mysql/schema.sql, install/mysql/data.sql, install/mysql/sample.sql ]
      less:
        application/site/public/theme/bootstrap/less: application/site/public/theme/bootstrap/css

Create an empty `config.yaml` file in the `config` directory and add the hosts you want to use. Any number of hosts can be added, but there must be at least one host with the name `nooku.vagrant`. The first line is the domain name.  The first parameter `dir` is the path to the local directory on the host system. Path will be expanded, so shortcuts like `~` can be used.

The second parameter `sql` is for database setup. This parameter is optional. If provided, the script will create the databases on each `vagrant up` and import the specified SQL files. The first word in the line under `sql` is the name of the database, followed by an array of SQL files to be imported. SQL files are optional, an empty array `[]` should be used in that case. Any number of databases can be specified under `sql`.

The third parameter is `less`. The server has `autoless` installed. Use the source file or directory as a key, destination as value, and autoless will automatically create the CSS files.

# Networking

Vagrant assigns the IP `192.168.50.10` to the virtual machine. Nginx uses name-based virtual hosts, so the host machine has to be configured to point domains to this IP.

1. Open /etc/hosts on your local system and add the domain names and to it:

        192.168.50.10   nooku.vagrant www.nooku.vagrant 53.nooku.vagrant 54.nooku.vagrant access.nooku.vagrant error.nooku.vagrant

2. Flush the cache:

        dscacheutil -flushcache

After this you can access the site at `http://nooku.vagrant/` (or whatever domain you chose).

# Usage

Setting up the Vagrant box is easy. Just `cd` into the directory of the nooku server repository and run `vagrant up`. The initial setup takes about 40-60 minutes and requires internet connection. To stop the system, execute `vagrant halt`. To completely destroy the virtual image, run `vagrant destroy`. To create the image again, run `vagrant up`. If you want to connect to the box using SSH, run `vagrant ssh`.

To access the database, create a standard connection with the IP `192.168.50.10`, and use `root` as username and password.

# PHP

## Versions

Nooku Server has multiple PHP version support, currently supported versions are 5.3 and 5.4. These can be used at the same time. This is setup allows you to test the application under both PHP versions. The main domain (for example `nooku.vagrant`) is configured to use PHP 5.4. Nginx automatically creates two subdomains: `53.nooku.vagrant` and `54.nooku.vagrant`. `54.nooku.vagrant` is actually the same as `nooku.vagrant`. `53.nooku.vagrant` however uses PHP 5.3.

## Developer tools

PHPunit, Composer and PHP Analyzer are also installed on the system. Executables can be found in `/usr/bin`.

## Xdebug

// TODO