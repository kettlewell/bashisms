#!/bin/bash

# read in a list of hosts, find mount points, and output results to file
# 
while read  line;
do
    echo -en "\n=================\n=   $line   =\n=================\n\n";
    ssh -o ConnectTimeout=3 -q ${line} "uname -r || echo 'COMMAND NOT FOUND'" || echo "NO RESPONSE"; echo -en "\n\n";
done < kernel.txt | tee kernel.out

