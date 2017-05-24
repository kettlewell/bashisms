#!/usr/bin/env bash -eu

CONSOLE_IP=''
CONSOLE_FQDN=''

#SCRIPT=`basename ${BASH_SOURCE[0]}`
SCRIPT=''

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
    SCRIPT="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
    #echo ${SCRIPT}
    #echo ${SOURCE}
}

get_script_dir


#Set fonts for Help.
NORM=`tput sgr0`
BOLD=`tput bold`
REV=`tput smso`

#Help function
function HELP {
  echo -e \\n"Help documentation for ${BOLD}${SCRIPT}.${NORM}"\\n
  echo -e "${REV}Basic usage:${NORM} ${BOLD}$SCRIPT -i IP -f FQDN ${NORM}"\\n
  echo "The following command line switches are recognized."
  echo "${REV}-h${NORM}  --Ask for help."
  echo "${REV}-i${NORM}  --Sets the console IP."
  echo "${REV}-f${NORM}  --Set the console FQDN."
  echo -e "Example: ${BOLD}$SCRIPT -i 10.1.1.1 ${NORM}"\\n
  echo -e "Example: ${BOLD}$SCRIPT -f hostname.domainname.com${NORM}"\\n
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

while getopts :f:i:h FLAG; do
  case $FLAG in
    i)  # console_ip
        CONSOLE_IP=${OPTARG}
        CONSOLE=${CONSOLE_IP}
        ;;
    h)  # help
        HELP
        ;;
    f) # console_fqdn
        CONSOLE_FQDN=${OPTARG}
        CONSOLE=${CONSOLE_FQDN}
      ;;
    \?) #unrecognized option - show help
      echo -e \\n"Unknown Option -${BOLD}$OPTARG${NORM}."
      HELP
      ;;
  esac
done

shift $((OPTIND-1))  #This tells getopts to move on to the next argument.

### Main loop to process files ###
if [[ -z "${CONSOLE// }" ]]; then echo "ERROR: UNKNOWN CONSOLE "; exit; fi

CREDS=${HOME}/.ssh/ilo.keys
# {
#     "UserName": "admin",
#     "Password": "supersecretpass"
# }

# Create an X-Auth token
TMP_CONSOLE=${CONSOLE//./_}
TMP_CONSOLE=${TMP_CONSOLE//-/_}

CONSOLE_OUT="${SCRIPT}/OUT/${TMP_CONSOLE}"
if [[ ! -d ${CONSOLE_OUT} ]]; then
    echo "${CONSOLE_OUT} DOES NOT exist. Creating."
    mkdir -p ${CONSOLE_OUT}
    if [ "$?" -ne "0" ]; then echo "ERROR creating ${CONSOLE_OUT}"; fi
fi

exit

# export ILO_AUTH_${CONSOLE//./_}="$(curl -H 'Content-Type: application/json' -H 'OData-Version: 4.0' -X POST --data @${CREDS} https://${CONSOLE}/redfish/v1/SessionService/Sessions/ -k -L -sS -D - | grep X-Auth-Token)";
export ILO_AUTH_${TMP_CONSOLE}="$(curl -H 'Content-Type: application/json' -H 'OData-Version: 4.0' -X POST --data @${CREDS} https://${CONSOLE}/redfish/v1/SessionService/Sessions/ -k -L -sS -D - | grep X-Auth-Token)";

ILO_X_AUTH="$(eval echo \$ILO_AUTH_${TMP_CONSOLE})"

# Network Adapter 1 ( Name / MAC )
#curl -H "${ILO_X_AUTH}"              \
#     -H "Content-Type: application/json" \
#     -H "OData-Version: 4.0"  \
#     https://${CONSOLE}/redfish/v1/systems/1/networkadapters/1/ -k -L -sS  \
#     | jq '.'
     #| jq '. | { Name: .Name,
     #           MacAddresses: [.PhysicalPorts[].MacAddress] }'

#curl -H "${ILO_X_AUTH}"              \
#     -H "Content-Type: application/json" \
#     -H "OData-Version: 4.0"  \
#     https://${CONSOLE}/redfish/v1/systems/1/networkadapters/2/ -k -L -sS  \
#    | jq '.'
    #| jq '. | { Name: .Name,
    #           MacAddresses: [.PhysicalPorts[].MacAddress] }'


# Testing
# exit

#curl -H "${ILO_X_AUTH}"              \
#     -H "Content-Type: application/json"                      \
#     -H "OData-Version: 4.0"                                  \
#     https://${CONSOLE}/redfish/v1/systems/1/ -k -L -sS       \
#    | jq '. | {state: .PowerState, health: .Status.Health}'


# Network Adapter 1 ( Name / MAC )
curl -H "${ILO_X_AUTH}"              \
     -H "Content-Type: application/json" \
     -H "OData-Version: 4.0"  \
     https://${CONSOLE}/redfish/v1/systems/1/networkadapters/1/ -k -L -sS  \
    | jq '. | { Name: .Name,
                MacAddresses: [.PhysicalPorts[].MacAddress],
                StatusHealth: [.PhysicalPorts[].Status] }'



# Network Adapter 2 ( Name / MAC )
curl -H "${ILO_X_AUTH}"                  \
     -H "Content-Type: application/json" \
     -H "OData-Version: 4.0"  \
     https://${CONSOLE}/redfish/v1/systems/1/networkadapters/2/ -k -L -sS  \
    | jq '. | { Name: .Name,
                MacAddresses: [.PhysicalPorts[].MacAddress],
                StatusHealth: [.PhysicalPorts[].Status]  }'

exit
# https://${CONSOLE}/redfish/v1/systems/1/
curl -H "${ILO_X_AUTH}"              \
     -H "Content-Type: application/json" \
     -H "OData-Version: 4.0"  \
     https://${CONSOLE}/redfish/v1/systems/1/ -k -L -sS   \
    | jq '. | { Model: .Model, SerialNumber: .SerialNumber, HealthStatus: .Status.Health }'

# https://${CONSOLE}/redfish/v1/systems/1/bios
curl -H "${ILO_X_AUTH}"              \
     -H "Content-Type: application/json" \
     -H "OData-Version: 4.0"  \
     https://${CONSOLE}/redfish/v1/systems/1/bios -k -L -sS \
    | jq '. | { AsrStatus: .AsrStatus, EmbSata1Enable: .EmbSata1Enable,
                EmbSata2Enable: .EmbSata2Enable,
                EmbeddedUefiShell: .EmbeddedUefiShell,EnergyPerfBias: .EnergyPerfBias,
                F11BootMenu: .F11BootMenu, IntelligentProvisioning: .IntelligentProvisioning,
                NicBoot1: .NicBoot1, NicBoot2: .NicBoot2,
                PciSlot2Enable: .PciSlot2Enable, PciSlot3Enable: .PciSlot3Enable,
                PowerOnLogo: .PowerOnLogo, PowerProfile: .PowerProfile,
                ProcHyperthreading: .ProcHyperthreading, ProcVirtualization: .ProcVirtualization,
                SetFilerialNumber: .SerialNumber, Slot3NicBoot1: .Slot3NicBoot1,
                ThermalConfig: .ThermalConfig, UefiPxeBoot: .UefiPxeBoot }'
