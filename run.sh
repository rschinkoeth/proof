#! /bin/sh
#install prerequisites
echo "installing prerequisites if needed"
sudo apt-get install -y virtualbox virtualbox-qt virtualbox-dkms vagrant &>/dev/null


SAVEIFS=$IFS    # save old IFS value
IFS=$'\n'       # make newlines the only separator
echo "vm cleanup"
for vm in $(VBoxManage list vms | fgrep 'deploy' | awk '{print substr($2, 2, length($2) - 2)}') # you might want to limit your search by `| grep 'some vm name here' ` *before* the pipe to awk
do
print $vm
echo "powering off vm id ${vm}"
VBoxManage controlvm ${vm} poweroff
echo "unregistering vm id ${vm}"
VBoxManage unregistervm --delete ${vm}
done


#remove prior virtualbox if existing
echo "removing .vagrant folder and powering up vm"
rm -rf deploy/.vagrant
cd deploy
vagrant up
vagrant ssh controller
sudo su
bash kolla/run-kolla.sh


