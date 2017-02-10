#!/bin/bash

while read -u10 line;
do
    echo $line;
    ssh -q -o ConnectTimeout=3 ${line} "echo 'RPM:';rpm -qa | grep gluster|| echo 'RPM NOT FOUND';echo 'UMOUNT:'; sudo umount -fl dr-gfs007x:/data; echo 'DONE'" || echo "NO CONNECT";
done  10< group-SC9-ALL-SERVERS.txt 

# all-sc9-hosts.txt
# test-server-input.txt
# group-SC9-ALL-SERVERS.txt
# group-SC9-ALL-WEBLOGIC.txt

