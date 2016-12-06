#!/bin/bash -eu
#
# This is a tailored solution for a particular use case... 
#
######################################################################
# Desc: DNS Verification - look at forward and reverse records for
#       front, back and console interfaces
#
# Author: Kettlewell
#
# Inputs:  -h hostname
#          -d domain
#
# Example:
#           ./dnsverify -h host -d domain.com
#
# TODO:
#         have -d take the datacenter name ( -d bos ), and hand it
#         DC specific DNS names for dig
#
#         better yet, -f fqdn, parse the DC from that...
#
######################################################################

DBG=0

#Set Script Name variable
SCRIPT=`basename ${BASH_SOURCE[0]}`

# DNS
DNS1='8.8.8.8'
DNS2='8.8.4.4'
DNS3='4.4.2.2'



DNS="@${DNS1} @${DNS2} @${DNS3}"


#Initialize variables to default values.
HOST=''
DOMAIN=''
FRONT=''
BACK=''
CONSOLE=''
FRONT_REV=''
BACK_REV=''
CONSOLE_REV=''


#Set fonts for Help.
NORM=`tput sgr0`
BOLD=`tput bold`
REV=`tput smso`

#Help function
function HELP {
  echo -e \\n"Help documentation for ${BOLD}${SCRIPT}.${NORM}"\\n
  echo -e "${REV}Basic usage:${NORM} ${BOLD}$SCRIPT file.ext${NORM}"\\n
  echo "Command line switches are optional. The following switches are recognized."
  echo "${REV}-h${NORM}  --Sets the host."
  echo "${REV}-d${NORM}  --Sets the domain."
  echo -e "Example: ${BOLD}$SCRIPT -h hostname -d domainname.com${NORM}"\\n
  exit 1
}

#Check the number of arguments. If none are passed, print help and exit.
NUMARGS=$#
# echo -e \\n"Number of arguments: $NUMARGS"
if [ $NUMARGS -eq 0 ]; then
  HELP
fi

### Start getopts code ###

#Parse command line flags
#If an option should be followed by an argument, it should be followed by a ":".
#Notice there is no ":" after "h". The leading ":" suppresses error messages from
#getopts. This is required to get my unrecognized option code to work.

while getopts :d:h: FLAG; do
  case $FLAG in
    d)  #set option "d"
	DOMAIN=$OPTARG
	if [[ ${DBG} > 0 ]];
	then
	    echo "-d used: $OPTARG"
	    echo "DOMAIN = ${DOMAIN}"
	fi
	
      ;;
    h)  #show help
	HOST=${OPTARG}
	if [[ ${DBG} > 0 ]];
	then
	    echo "-h used: $OPTARG"
	    echo "HOST = ${HOST}"
	fi
	
      ;;
    \?) #unrecognized option - show help
      echo -e \\n"Option -${BOLD}$OPTARG${NORM} not allowed."
      HELP
      #If you just want to display a simple error message instead of the full
      #help, remove the 2 lines above and uncomment the 2 lines below.
      #echo -e "Use ${BOLD}$SCRIPT -h${NORM} to see the help documentation."\\n
      #exit 2
      ;;
  esac
done

shift $((OPTIND-1))  #This tells getopts to move on to the next argument.

### End getopts code ###

### Main loop to process files ###
printf "\n%-40s | %-15s | %-30s\n" "FORWARD"  "IP"          "REVERSE"
printf "==========================================================================================\n"


FRONT=${HOST}.${DOMAIN}
BACK=${HOST}x.${DOMAIN}
CONSOLE=${HOST}-console.${DOMAIN}

if [[ ${DBG} > 0 ]];
then
    printf "dig ${DNS} +short $FRONT"
fi

FRONT_IP=`dig ${DNS} +short $FRONT`
BACK_IP=`dig ${DNS} +short $BACK`
CONSOLE_IP=`dig ${DNS} +short $CONSOLE`
FRONT_TXT=`dig ${DNS} +short $FRONT TXT`
FRONT_REV=`dig ${DNS} +short -x ${FRONT_IP}`

CONSOLE_REV=`dig ${DNS} +short -x ${CONSOLE_IP}`
if [[ ! -z "${BACK_IP}"  ]];
then
   BACK_REV=`dig ${DNS} +short -x ${BACK_IP}`
fi
   
printf "%-40s | %-15s | %-30s\n" ${FRONT}   ${FRONT_IP}   ${FRONT_REV}
printf "%-40s | %-15s | %-30s\n" ${BACK}    ${BACK_IP}    ${BACK_REV}
printf "%-40s | %-15s | %-30s\n\n" ${CONSOLE} ${CONSOLE_IP} ${CONSOLE_REV}
printf "\nTXT RR:  %s\n" ${FRONT_TXT}

### End main loop ###

exit 0

