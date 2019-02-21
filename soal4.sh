#!/bin/bash

date | awk -F ":" '{print $1}' | awk '{print $4}' > jam.txt
date | awk '{print $4}' | awk -F ":" '{print $1":"$2}' > jamu.txt
date | awk '{print $3"-"$2"-"$6}' > tgl.txt
a=abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz
b=ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ
string=$(echo "$(cat /var/log/syslog)")
plus=$(cat jam.txt)
jam=$(cat jamu.txt)
tgl=$(cat tgl.txt)
newstring=$(echo $string | tr "${a:0:26}" "${a:${plus}:26}")
newstring=$(echo $newstring | tr "${b:0:26}" "${b:${plus}:26}")
echo ${newstring} > $jam\ $tgl.log
