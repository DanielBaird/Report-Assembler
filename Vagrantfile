# -*- mode: ruby -*-
# vi: set ft=ruby :

# -------------------------------------------------------------------
# a Vagrantfile can contain Ruby, so here we're using that to assign
# a string value that is our provisioning shell script to a variable.
# The proper parts of the Vagrantfile come after this bit.

$provisioning_script = <<SCRIPT_TERMINATOR
# now in shell script..

#
# apt-get all the stuff we might need
#
echo ''
echo ' *************************************************************'
echo ' ************************************  apt-getting everything '
echo ' *************************************************************'
apt-get update
apt-get -y install build-essential g++ python-software-properties python curl libssl-dev apache2-utils git-core
add-apt-repository ppa:chris-lea/node.js
apt-get update
apt-get -y install nodejs

#
# compile node from source
#
# echo ''
# echo ' *************************************************************'
# echo ' ********************************************  compiling node '
# echo ' *************************************************************'
# git clone git://github.com/joyent/node.git node
# cd node
# ./configure
# make
# make install

#
# install node libs
#
npm install -g jasmine-node coffee-script uglify-js

#
# all done.
#
echo ''
echo ' *************************************************************'
echo ' *************************************************  all done! '
echo ' *************************************************************'

echo ''
SCRIPT_TERMINATOR
# -------------------------------------------------------------------
# Actual Vagrantfile content follows..

Vagrant.configure("2") do |config|
	# the special name of the box to clone when making this vm
	config.vm.box = "precise32"

	# the url to get the original box from, if you don't have it cached
	config.vm.box_url = "http://files.vagrantup.com/precise32.box"

	# provision the VM via these shell commands, provided inline (as a var)
	config.vm.provision :shell, :inline => $provisioning_script

	# forward ports, host:4567 to vm:80
	config.vm.network :forwarded_port, :host => 4567, :guest => 80
end
