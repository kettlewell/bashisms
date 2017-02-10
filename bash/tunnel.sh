#!/bin/bash

if [[ "$#" -ge "1" ]]
then
    if [[ "$1" == "-u" ]]
    then
	kextunload /Library/Extensions/tun.kext
	kextunload /Library/Extensions/tap.kext
    elif [[ "$1" == "-l" ]]
    then
	kextload /Library/Extensions/tun.kext
	kextload /Library/Extensions/tap.kext
    else
	echo "what?"
	echo "usage: tunnel.sh [-u] [-l] # Tunnel Load or Unload "
    fi
fi


