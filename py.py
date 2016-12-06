#!/usr/bin/env python3
'''
Its time to start writing things in python3 only now.

These are snippets of code I've found while studying or an example in a book
They are by no means complete examples.
'''
## System Modules
import os
import sys

## Third Party Modules
from urllib.parse import parse_qs

## My Modules


# convert to string
def to_str(bytes_or_str):
    if isinstance(bytes_or_str,bytes):
        value = bytes_or_str.decode('utf-8')
    else:
        value = bytes_or_str
    return value  # Instance of str

# convert to bytes
def to_bytes(bytes_or_str):
    if isinstance(bytes_or_str,str):
        value = bytes_or_str.encode('utf-8')
    else:
        value = bytes_or_str
    return value # Instance of bytes

# note that the wb is required for python3
def write_binary():
    with open('/tmp/random.bin','wb') as f:
        f.write(os.urandom(10))


# parse example
def myparse():
    my_values = parse_qs('red=5&blue=0&green=', keep_blank_values=True)
    print(repr(my_values))

def usage_example():
    print("""\
    Usage: binary [opt 1] [opt 2] filename
           -h               ===     Help
           -H hostname      ===     use this host
    """)

