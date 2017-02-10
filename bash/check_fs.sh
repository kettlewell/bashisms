#!/bin/bash
#
# This was a one off script tailored for a particular use case.
# Custom script that uses ILO utilityes to check for things like:
#
#        filesystem type ( ext vs xfs )
#        filesystem size
#        RAID type

##################
#   RETURN CODES #
##################
#
# SIZE_STATUS
#    ERROR - LUN Not Fully Utilized ( likely needs xfs applied )
#    OK    - LUN space used
#
# FS_STATUS
#    ERROR - ext3,ext4
#    OK    - xfs
#
# RAID_STATUS 
#    ERROR - RAID 5 was found
#    OK    - RAID 1, RAID 1+0
#
#   
# Example Usage:
#   ssh -q ${remote_host} "bash -s" -- < check_fs.sh
#
#   ssh -q ${remote_host} "bash -s" -- < check_fs.sh | tee outputfile.out
#
#   while read -r line;
#   do
#      ssh -q ${remote_host} "bash -s" -- < check_fs.sh;
#   done < inputfile.in | tee outputfile.out
#
###############################################################

SIZE_WARN=0
FS_WARN=0
RAID_WARN=0

HOST="`hostname -f`"
RAW_SIZE="`df -h /data1 | tail -1`"
RAW_MOUNT="`mount | grep /data1`"


if [[ -f /usr/sbin/hpacucli ]];
then
   RAW_RAID="`sudo /usr/sbin/hpacucli controller all show config | grep RAID`"
elif [[ -f /usr/sbin/hpssacli ]];
then
   RAW_RAID="`sudo /usr/sbin/hpssacli controller all show config | grep RAID`"
fi

RAID=$(echo ${RAW_RAID} | grep --null -oE "RAID [1-9]\+?[0-9]?" | tr '\n' ':')
SIZE=$(echo ${RAW_SIZE} | awk '{print $2}')
FSTYPE=$(echo ${RAW_MOUNT} | grep -oE 'xfs|ext4|ext3')
LUN2_SIZE=$(sudo /usr/sbin/hpssacli controller all show config | grep -oE 'logicaldrive 2.*TB' | grep -oE "[0-9]{0,3}\.[0-9]{0,3}")
USABLE_SIZE=$(echo ${SIZE} | tr -d 'T')
RAID5=$(echo ${RAID} | grep 5)

if [[ ${USABLE_SIZE} < ${LUN2_SIZE} ]]
then
    SIZE_WARN=$((${SIZE_WARN} + 1))
fi

if [[ ${FSTYPE} != "xfs" ]]
then
    FS_WARN=$((${FS_WARN}+1))
fi

if [[ ! -z ${RAID5} ]]
then
   RAID_WARN=$((${RAID_WARN}+1))
fi

printf "\nSTART===================================================\n\n"
printf "%-20s [%s]\n" "HOST" "${HOST}"

if [[ ${SIZE_WARN} -gt 0 ]]
then
    printf "%-12s: %-6s [%s]\n" "SIZE_STATUS" "ERROR" "${HOST}"
else
    printf "%-12s: %-6s [%s]\n" "SIZE_STATUS" "OK" "${HOST}"
fi

if [[ ${FS_WARN} -gt 0 ]]
then
    printf "%-12s: %-6s [%s]\n" "FS_STATUS" "ERROR" "${HOST}"
else
    printf "%-12s: %-6s [%s]\n" "FS_STATUS" "OK" "${HOST}"
fi

if [[ ${RAID_WARN} -gt 0 ]]
then
    printf "%-12s: %-6s [%s]\n" "RAID_STATUS" "ERROR" "${HOST}"
else
    printf "%-12s: %-6s [%s]\n" "RAID_STATUS" "OK" "${HOST}"
fi

printf "\nRAW OUTPTUT  =====\n\n"
printf "%s\n" "${RAW_SIZE}"
printf "%s\n" "${RAW_MOUNT}"

printf "%s\n\nREFINED OUTPUT  =====\n" "${RAW_RAID}"
printf "%-13s: %-10s\n" "SIZE" "${SIZE}"
printf "%-13s: %-10s\n" "FILESYSTEM" "${FSTYPE}"
printf "%-13s: %-10s\n" "RAID" "${RAID}"

printf "\nEND=====================================================\n\n"
