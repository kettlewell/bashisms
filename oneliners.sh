#!/usr/bin/bash

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
