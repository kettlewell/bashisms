#!/bin/env bash
#
# Measure network usage for an interface, using only the /proc filesystem
#
# Heavily borrowed from this stack exchange:
# http://unix.stackexchange.com/a/20968
#

_die() {
    printf '%s\n' "$@"
    exit 1
}

_header() {
    printf '%10s%10s%10s%10s%10s%10s\n' \
	   "BYTES IN"   \
	   "BYTES OUT"  \
	   "KBYTES IN"  \
	   "KBYTES OUT" \
	   "MBITS IN"   \
	   "MBITS OUT"
}

_interface=$1
_count=0
_remainder=0

[[ ${_interface} ]] || _die 'Usage: ifspeed [interface]'
grep -q "^ *${_interface}:" /proc/net/dev || _die "Interface ${_interface} not found in /proc/net/dev"

_interface_bytes_in_old=$(awk "/^ *${_interface}:/"' { if ($1 ~ /.*:[0-9][0-9]*/) { sub(/^.*:/, "") ; print $1 } else { print $2 } }' /proc/net/dev)
_interface_bytes_out_old=$(awk "/^ *${_interface}:/"' { if ($1 ~ /.*:[0-9][0-9]*/) { print $9 } else { print $10 } }' /proc/net/dev)

while sleep 1; do
    _remainder=$(( ${_count} % 15 ))
    if [ ${_remainder} -eq 0 ];
    then
	_header
    fi
    
    _interface_bytes_in_new=$(awk "/^ *${_interface}:/"' { if ($1 ~ /.*:[0-9][0-9]*/) { sub(/^.*:/, "") ; print $1 } else { print $2 } }' /proc/net/dev)
    _interface_bytes_out_new=$(awk "/^ *${_interface}:/"' { if ($1 ~ /.*:[0-9][0-9]*/) { print $9 } else { print $10 } }' /proc/net/dev)

    printf '%10s%10s%10s%10s%10s%10s\n' \
	   "$(( _interface_bytes_in_new - _interface_bytes_in_old ))"                \
	   "$(( _interface_bytes_out_new - _interface_bytes_out_old ))"              \
	   "$(( ( _interface_bytes_in_new - _interface_bytes_in_old ) / 1024 ))"     \
	   "$(( ( _interface_bytes_out_new - _interface_bytes_out_old ) / 1024 ))"   \
	   "$(( ( _interface_bytes_in_new - _interface_bytes_in_old ) / 131072 ))"   \
	   "$(( ( _interface_bytes_out_new - _interface_bytes_out_old ) / 131072 ))"
    
     _interface_bytes_in_old=${_interface_bytes_in_new}
     _interface_bytes_out_old=${_interface_bytes_out_new}
     _count=$((${_count}+1))
done



