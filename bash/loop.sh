#!/bin/bash
# usage:
#       loop.sh filename.txt
# Desc:
#      reads one line at a time from an input file
#

infile="${1}"

while read -r line
do
    name="${line}"
    echo "${name}"
done < "${infile}"

