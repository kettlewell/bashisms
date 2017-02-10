#!/usr/bin/env python3

# Create a SSH connection
import paramiko
import os

import pprint
pp = pprint.PrettyPrinter(indent=4)

ssh = paramiko.SSHClient()
ssh._policy = paramiko.WarningPolicy()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

ssh_config = paramiko.SSHConfig()
user_config_file = os.path.expanduser("~/.ssh/config")
if os.path.exists(user_config_file):
    with open(user_config_file) as f:
        ssh_config.parse(f)

cfg = {'hostname': 'dr-gfs00702.svale.netledger.com'}

user_config = ssh_config.lookup(cfg['hostname'])


cfg["hostname"] = user_config["hostname"]
cfg["username"] = user_config["user"]

if 'identityfile' in user_config:
    cfg['key_filename'] = user_config['identityfile']
#key=paramiko.RSAKey.from_private_key_file(pkey)
#cfg["pkey"] = key

if 'proxycommand' in user_config:
   cfg['sock'] = paramiko.ProxyCommand(user_config['proxycommand'])

ssh.connect(**cfg)
stdin, stdout, stderr = ssh.exec_command("ls -al")
        
for out_line in stdout.readlines():
        pp.pprint(out_line)

for err_line in stderr.readlines():
        pp.pprint(err_line)

ssh.close()
