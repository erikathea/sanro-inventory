#!/bin/bash

cd /home/sanro/sanro-inventory
pwd
echo $PATH
rvm use 2.1.3

ifconfig eth0 | grep inet | awk '{print $2}' | cut -d':' -f2
a=`ifconfig eth0 | grep inet | awk '{print $2}' | cut -d':' -f2`
echo $a
exit 0
