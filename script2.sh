#!/bin/bash
cd /home/sanro/sanro-inventory
ip="$(ifconfig | grep -A 1 'eth0' | tail -1 | cut -d ':' -f 2 | cut -d ' ' -f 1)"
#ip=`ifconfig eth0 | grep inet | awk '{print $2}' | cut -d':' -f2`
echo $ip
terminator -e 'rails s -b 0.0.0.0'
exit 0
