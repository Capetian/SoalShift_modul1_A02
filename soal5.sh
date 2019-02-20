#!/bin/bash

dir="$HOME/modul1"

if [[ ! $HOMEmodul1  ]];  then 
   mkdir $dir
fi


awk 'tolower($0) ~ /cron/ && !/sudo/ && NF<13' /var/log/syslog >> $dir/log.txt

