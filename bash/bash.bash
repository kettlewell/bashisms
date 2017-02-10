#!/usr/bin/env bash -eu

# This script shouldn't ever really be run...
# just a list of snippets & one-liners
exit 1

# TODO:  Create Table of Contents to find stuff easier

# count of connections in each state ( ESTABLISHED, CLOSE_WAIT, etc )
netstat -tn | awk 'NR>2{cnt[$6]++} END {for(k in cnt) { print k, cnt[k] } }'

# generate .p12 / pfx certs
openssl pkcs12 -export -out wild.p.netsuite.com.p12 -inkey vs2017_wild.p.netsuite.com.key -in vs2017_wild.p.netsuite.com.crt


# Loop through and print the hostname using printf syntax
for x in {1..5};
do
    ssh -o ConnectTimeout=3 -q f-kafka0660${x}.svale.netledger.com "printf '${x}) %s:   ' $(hostname -f) ; rpm -qa | grep kafka"
done


# Get the directory of the script we're running from
#
get_script_dir () {
     SOURCE="${BASH_SOURCE[0]}"
     # While $SOURCE is a symlink, resolve it
     while [ -h "$SOURCE" ]; do
          DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
          SOURCE="$( readlink "$SOURCE" )"
          # If $SOURCE was a relative symlink (so no "/" as prefix, need to resolve it relative to the symlink base directory
          [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
     done
     DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
     echo "$DIR"
}


# TCP or UDP port check with bash
# TODO: create a script that takes inputs of host/port and gives better outputs
timeout 1 bash -c 'cat < /dev/null > /dev/tcp/my.fqdn.com/9092'; echo $0

# list of servers from icinga using jq
jq -r '.[].host_display_name' icinga_output.json | sort -u


# rolling restart of Puppet. Not the use of file descriptor 10
while read -u10 line;
do
    echo $line;
    ssh -q  -o ConnectTimeout=5 ${line} "sudo /etc/init.d/puppet stop; sudo puppet agent -tv; sudo /etc/init.d/puppet start";
done 10< serverlist.txt



# Gluster write perf
sudo gluster volume top data write-perf bs 2048 count 100 list-cnt 5 | grep Throughput -B1




# System Diagnostic Commands
#   - most of these I know already, here as a reminder

# lspci commands
lspci
lspci -vvvvv
lspci -tv
lspci -n

sar -A
sar -r

lsmod
dmidecode

iostat -m 1 5
vmstat 1 5

top -n 1 -b

ps aux
ps aux --sort start_time

numactl --hardware
numactl --show
numastat



# Find available DNS ranges from BIND file
awk '/IN.*10.1.66./ {print $4}' db.svale | sort -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4 | cut -f4 -d'.' | awk 'BEGIN{prev=0} {if ($1 != prev+1){ print $1}; prev=$1}'

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
