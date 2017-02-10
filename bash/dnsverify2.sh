#!/bin/bash -eu

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
#           ./dnsverify -h hostname -d domainname.com 
#
# TODO:
#      add -f fqdn
#
######################################################################

#Set Script Name variable
SCRIPT=`basename ${BASH_SOURCE[0]}`
DNS='10.1.196.211'

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
      # echo "-d used: $OPTARG"
      # echo "DOMAIN = ${DOMAIN}"
      ;;
    h)  #show help
      HOST=${OPTARG}
      # echo "-h used: $OPTARG"
      # echo "HOST = ${HOST}"
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

FRONT=${HOST}.${DOMAIN}
BACK=${HOST}x.${DOMAIN}
CONSOLE=${HOST}-console.${DOMAIN}


FRONT_IP=`dig @${DNS} +short $FRONT`
BACK_IP=`dig @${DNS} +short $BACK`
CONSOLE_IP=`dig @${DNS} +short $CONSOLE`


FRONT_REV=`dig @${DNS} +short -x ${FRONT_IP}`
BACK_REV=`dig @${DNS} +short -x ${BACK_IP}`
CONSOLE_REV=`dig @${DNS} +short -x ${CONSOLE_IP}`

printf "\n%-40s | %-15s | %-30s\n" "FORWARD"  "IP"          "REVERSE"
printf "==========================================================================================\n"
printf "%-40s | %-15s | %-30s\n" ${FRONT}   ${FRONT_IP}   ${FRONT_REV}
printf "%-40s | %-15s | %-30s\n" ${BACK}    ${BACK_IP}    ${BACK_REV}
printf "%-40s | %-15s | %-30s\n\n" ${CONSOLE} ${CONSOLE_IP} ${CONSOLE_REV}


### End main loop ###

exit 0

