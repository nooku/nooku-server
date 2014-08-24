# Changelog

## 3.1.0 (24 Aug 2014)

- Added - Installed Varnish cache in front of Nginx
- Added - Created `varnish` command to manage Varnish
- Added - Install PEAR packages Console_CommandLine and Phing by default
- Improved - Allow VM to be configured through config.custom.yaml file. (# CPU's, memory and VM name)
- Improved - Support new bootstrapper.php configuration file.
- Added - Set path mappings through the BOX_SHARED_PATHS environment variable.
- Improved - Updated Virtualbox guest additions to 4.3.14

## 3.0.1 (21 Jun 2014)

- Added - Setup the /apc alias to access APC dashboard
- Added - Included the /phpinfo location as a shortcut to phpinfo();
- Added - Installed PEAR, PECL
- Added - Installing the PECL yaml extension by default
- Improved - Updated Virtualbox guest additions to 4.3.12

## 3.0.0 (12 May 2014)

- Fixed - PHP-FPM should create the socket as user www-data.
- Added - Merged vagrant configuration from nooku-framework back into nooku-server.
- Added - Included the purge.sh script, used for packaging the box.
- Fixed - Use different VMWare names: nooku-box-build when building the box, nooku-box for plain Nooku Framework use.
- Improved - Nooku Framework can now download nooku/box instead of building it from scratch.

## 2.0.1 (22 Mar 2013):
- 273: Use nooku.vagrant as default hostname instead of nooku.dev.
- 272: Add Webgrind (available at webgrind.nooku.vagrant).
- 274: Add YAML extension to PHP.

## 2.0.0 (18 Mar 2013):

- 258: Replace Chef provisioning by Puppet. Add multiple host support.
- 260: Add multiple PHP version support (5.3 and 5.4).
- 261: Add developer tools (Git, Subversion, Zip, Unzip, Vim).
- 262: Add PHP tools (PHPunit and Composer).
- 263: Replace MySQL by Percona Server.
- 265: Fix Xdebug configuration.
- 266: Add LESS support and the autoless script.
- 267: Add ability to import SQL scripts on vagrant up.
- 268: Add PHP Analyzer.
- 270: Add easy access to access and error logs.
- 271: Add Vagrant 1.1 support.

## 1.0.0 (4 March 2013):

- Add Vagrant 1.0 support.
- Add Chef provisioning.
- Install and configure PHP, Nginx and MySQL.
