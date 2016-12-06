#!/usr/bin/env python3
'''
KS ( Kettlewell Suite ) Base Script to run other tools in a suite

create an organized system of tools that will take in 
pre-defined command line arguments, and perform modular
actions

EXAMPLE:

    ./ks.py <command> <cmd args...>
 
    ./ks.py help

    ./ks.py help commands

    ./ks.py help <command>
   
    ./ks.py check_backups -d db
 
COMMAND LIST:        

- compare
- check_backups

NOTES / IDEAS / ETC:

- Check machine you're running from 
  ( some only run from certain admin machines for example )

- create a module for each command

- main file should set up logging and parse/verify 
  command line args 

- 


'''
