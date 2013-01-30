Vagrant uses Oracle’s VirtualBox to build configurable, lightweight, and portable virtual machines dynamically.

# Installation

1. Download and install VirtualBox. Nothing else needs to be done, you even don't need to open it after install, Vagrant uses the command line interface of VirtualBox.

2. Download and install Vagrant: http://docs.vagrantup.com/v1/docs/getting-started/index.html

3. Vagrant needs to create a shared directory between your local system and Ubuntu. For this, edit the following line in Vagrantfile:

    config.vm.share_folder 'source', '/var/www/nooku-server/source', '/Users/Example/Workspace/nooku-framework'

The last argument should point to the root of the Nooku Framework repository on your local system. Note: This is a temporary solution, in later versions you won't have to edit the versioned Vagrantfile.

Because Vagrant creates a shared folder for the specified paths, you can modify files locally like you would do otherwise. Changes will be immediately available on the server. Think about it like a symlink, where your local directory is the source, and the directory on the server is the symlink.

3. In the Nooku Server repository run the following command:

    vagrant up

It will take some time to run, because first it needs to download the Ubuntu image if you haven't downloaded it before, and then it needs to install packages and configure services. After the Ubuntu image is downloaded it usually takes less than 10 minutes.

4. Create local host config. Open /etc/hosts on your local system and add the host to it:

    192.168.50.10   nooku.dev

Flush the cache:

dscacheutil -flushcache

And after that you can access the site at http://nooku.dev/ (or whatever hostname you chose).

Some useful Vagrant commands:
 - vagrant destroy: Destroys the environment (including the VirtualBox image). To create the image again, run vagrant up.
 - vagrant halt: Stops Ubuntu. To start it again run vagrant up.
 - vagrant ssh: Connects to the Ubuntu box via SSH.

# Access

To access the Ubuntu box, execute "vagrant up" in repository/code.
To access the database, use "Standard" connection with 192.168.50.10 as host and "root" as username and password.

# Xdebug

Xdebug is configured on the server. It is set to listen on port 9001.