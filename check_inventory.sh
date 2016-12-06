#!/bin/bash
# Script to check inventory of various components on systems
#  Clean up later ...
#
#        MEMORY
#        CACHE BATTERY
#        LUN CONFIG
#        TXT RECORD

##################
#   RETURN CODES #
##################
#
# XXX_STATUS
#    ERROR - 
#    OK    - 
#
# Usage:
#   ssh -q ${remote_host} "bash -s" -- < check_inventory.sh
#
#
###############################################################


# HOST
HOST="`hostname -f`"

# MEMORY
MEMORY=`sudo grep MemTotal: /proc/meminfo | awk '{print $2/(2^20) " GB"}'`

# LUN / CACHE BATTERY
if [[ -f /usr/sbin/hpacucli ]];
then
    BATTERY=`sudo /usr/sbin/hpacucli controller slot=0 show |grep Board`
    LUN="`sudo /usr/sbin/hpacucli controller all show config`"
elif [[ -f /usr/sbin/hpssacli ]];
then
    BATTERY=`sudo /usr/sbin/hpssacli controller slot=0 show |grep Board`
    LUN="`sudo /usr/sbin/hpssacli controller all show config`"
fi

printf "\nSTART===================================================\n\n"
printf "%-20s [%s]\n" "HOST" "${HOST}"
printf "%-20s [%s]\n" "MEMORY" "${MEMORY}"
printf "%-20s [%s]\n" "BATTERY" "${BATTERY}"
printf "%-20s [%s]\n" "LUN" "${LUN}"
printf "\nEND=====================================================\n\n"
