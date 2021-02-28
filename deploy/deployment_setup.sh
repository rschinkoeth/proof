#! /bin/sh

cp /vagrant/deployment_interfaces /etc/network/interfaces
cp /vagrant/hosts /etc/hosts
cp /vagrant/grub /etc/default/grub

update-grub
add-apt-repository  -y ppa:deadsnakes/ppa

apt update -y
apt upgrade -y

##use python 3.9
rm -rf /usr/bin/python3
ln -s /usr/bin/python3.9 /usr/bin/python3


apt install -y python-jinja2 python3.9 python3.9-distutils libssl-dev
apt install -y lvm2 thin-provisioning-tools curl
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py --force-reinstall


pip3 install -U pip

pvcreate /dev/sdc
vgcreate cinder-volumes /dev/sdc

echo "configfs" >> /etc/modules
update-initramfs -u
systemctl daemon-reload

mkdir -p /home/vagrant/kolla
cp /vagrant/globals.yml /home/vagrant/kolla
cp /vagrant/run-kolla.sh /home/vagrant/kolla
cp /vagrant/init-runonce /home/vagrant/kolla

reboot
