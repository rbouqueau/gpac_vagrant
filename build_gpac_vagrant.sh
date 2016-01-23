#!/bin/bash
set -eu

#init VM and connect
vagrant box add hashicorp/precise64
vagrant init precise64 hashicorp/precise64 #changes default 'vagrant init' with 'config.vm.box = "hashicorp/precise64"'

#start VM
vagrant up

#connect
vagrant ssh

#setup passwd -> 'vagrant' as a su password
sudo passwd root

#connect as root
su -

#sudo
pico /etc/sudoers.d/vagrant
sudo chmod 0440 /etc/sudoers.d/vagrant
# Add this:
# # add vagrant user
# vagrant ALL=(ALL) NOPASSWD:ALL

#leave sudo
exit

#update the VM
sudo apt-get update -y
sudo apt-get upgrade -y

#reboot kernel if necessary
sudo shutdown -r now
vagrant ssh

#setup remote key
#mkdir -p /home/vagrant/.ssh
#chmod 0700 /home/vagrant/.ssh
#wget --no-check-certificate \
#  https://raw.github.com/rbouqueau/gpac_vagrant/master/keys/vagrant.pub \
#  -O /home/vagrant/.ssh/authorized_keys
#chmod 0600 /home/vagrant/.ssh/authorized_keys
#chown -R vagrant /home/vagrant/.ssh

#install VirtualBox specials so that people have a GUI
sudo apt-get install -y gcc build-essential linux-headers-server
#TODO: add the ISO with the Guest Additions
sudo mount /dev/cdrom /mnt 
cd /mnt
sudo ./VBoxLinuxAdditions.run
cd -

#install GPAC build env
sudo apt-get install git make pkg-config g++ zlib1g-dev libfreetype6-dev libjpeg62-dev libpng12-dev libopenjpeg-dev libmad0-dev libfaad-dev libogg-dev libvorbis-dev libtheora-dev liba52-0.7.4-dev libavcodec-dev libavformat-dev libavutil-dev libswscale-dev libxv-dev x11proto-video-dev libgl1-mesa-dev x11proto-gl-dev linux-sound-base libxvidcore-dev libssl-dev libjack-dev libasound2-dev libpulse-dev libsdl1.2-dev dvb-apps libavcodec-extra-53 libavdevice-dev libmozjs185-dev
git clone https://github.com/gpac/gpac
cd gpac
./configure
make -j4
sudo make install

#prepare package for share
sudo dd if=/dev/zero of=/EMPTY bs=1M
sudo rm -f /EMPTY
exit #exit the vagrant box
vagrant package --base vagrant-gpac



