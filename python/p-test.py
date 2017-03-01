#!/usr/bin/env python3
'''
Force Python3
'''

from __future__ import print_function
from pprint import pprint

from pssh.pssh_client import ParallelSSHClient

from pssh.exceptions import AuthenticationException, \
  UnknownHostException, ConnectionErrorException

import pssh.utils
pssh.utils.enable_host_logger()

hosts = ['vm-dc-js00001-dnguyen.svale.netledger.com']
client = ParallelSSHClient(hosts,proxy_host='nx')

try:
    print("before run_command")
    output = client.run_command('ls -ltrh /home/mkettlewell', stop_on_errors=False)
    print("after run_command")
    client.join(output)
    print(output)



    for host in output:
        for line in output[host]['stdout']:
            print("Host %s - output: %s" % (host, line))


except (AuthenticationException, UnknownHostException, ConnectionErrorException):
    print("exception...")
    pass
