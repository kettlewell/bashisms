#!/usr/bin/env bash -eu

# nmap for potentially available ip addresses on the network
for x in `sudo nmap -n -PE 192.168.202.0/24 -oG - | awk '/Down/{print $2}'`;
do
    if [[ ! `dig +short -x ${x}` ]];
    then
	echo ${x};
    fi
done

# start named screen session
screen -S session-name

# attach/create session
screen -dRR session-name

# find oracle instances running on a machine
ps  U oracle ho args | gawk 'match($0, /^ora_pmon_(.*)$/, m) { print m[1]; }'


# find mounts on remote machines
# 
while read -r line;
do
    echo -en "$line   ";
    ssh -q ${line} "mount|grep mountpoint || echo 'NO MOUNT'" || echo "NO ROUTE";
done <<< "hostname"

# grab a list of all hosts
# Nameserver
awk ' $1 ~/^hostname/ {print $1}' /var/named/master/db.hostfile | grep -vE "console|new|old|bad" > /tmp/hostname-list.txt

# read in a list of hosts, find mount points, and output results to file
# 
while read  line;
do
    echo -en "\n=================\n=   $line   =\n=================\n\n";
    ssh -q ${line} "mount|grep mountpoint || echo 'NO MOUNT'" || echo "NO ROUTE"; echo -en "\n\n";
done < hostname-list.txt2 > hosts-mounts.txt2


# show all information on the remote host, via ILO
ssh admin@ilo-console show -a

# find MAC addresses through ILO
ssh admin@ilo-console show /system1/network1/Integrated_NICs


# find switch port NIC is connected to
sudo lldpctl eth1 |grep PortID

# 
# sort list of IP addresses numerically
sort -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4
sort -V

# identify if a single remote machine has a named mountpoint or not
while read -r line; do echo -en "$line   "; ssh -q ${line} "mount|grep mounted_directory || echo 'NO MOUNT'" || echo "NO ROUTE"; done <<< "server-name"


# read in a list of servers, find mount points, and output results to file
while read  line;
do
    echo -en "\n=================\n=   $line   =\n=================\n\n";
    ssh -q ${line} "mount|grep mount_point || echo 'NO MOUNT'" || echo "NO ROUTE"; echo -en "\n\n";
done < server-list.txt > server-results.txt
