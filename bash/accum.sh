#!/bin/bash

nodes=''  
for x in {25..40}; do nodes="${nodes} dr-gfs007${x}"; done

echo ${nodes}
