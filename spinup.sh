#!/bin/bash

containsElement () {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}

vmlist="vmlist"
vm_tmpl="extra_template"

if [ ! -f $vmlist ]
then
	touch $vmlist
fi

extradirs=`find * -regextype posix-extended -regex '^worker[0-9]+' -type d | sed 's/worker//' | sort`
echo $extradirs

free=1

for (( i=1; i<100; i++ ))
do
	containsElement $i $extradirs
	if [ $? -eq 1 ]; then
		free=$i
		break
	fi
done

echo $free

newdir="worker"$free
cp -r $vm_tmpl $newdir

cd $newdir
newip='worker_config\.vm\.network\ \"private_network\"\,\ ip\: \"10\.0\.0\.'$((20+$free))'\"'
newhostname='worker_config\.vm\.hostname\ =\ \"worker'$free'\"'
newvmname='config\.vm\.define\ \:worker'$free'\ do\ \|worker_config\|'
newvbname='vb\.name\ =\ \"worker'$free'\"'

sed -i 's/vb\.name\ =\ \"worker.*/'"$newvbname"'/' Vagrantfile
sed -i 's/config\.vm\.define\ \:worker.*/'"$newvmname"'/' Vagrantfile
sed -i 's/worker_config\.vm\.network.*/'"$newip"'/' Vagrantfile
sed -i 's/worker_config\.vm\.hostname.*/'"$newhostname"'/' Vagrantfile

#newip="10\.0\.0\."$((20+$free))
#sed -i "s/WORKER_HOST=.*/WORKER_HOST='worker_"$free"'/" files/zabbix/zbx_create_host.sh
#sed -i "s/WORKER_IP=.*/WORKER_IP='"$newip"'/" files/zabbix/zbx_create_host.sh

vagrant global-status --prune
vagrant up

