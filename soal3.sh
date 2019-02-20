#!/bin/bash

loop=1
pass=""
while [  $loop == 1 ] 
 do
  seed=$(date +%s%N)
  pass=$(echo $seed | sha256sum | base64 | head -c 12)
  if [[ $pass =~ ^.*[0-9]+.*$ && $pass =~ ^.*[A-Z]+.*$  && $pass =~ ^.*[a-z]+.*$ ]];
     then loop=0
  fi
done

name="password"
index=1
if [[ -e $name$index.txt ]]; 
   then
   while [[ -e $name$index.txt ]];
      do
      let index++
    done
fi
name=$name$index
echo $pass > $name.txt



