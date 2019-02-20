#!/bin/bash

gen_pass() {
loop=1
pass=""
while [[  $loop == 1 ]]; 
 do
  seed=$(date +%s%N)
  pass=$(echo $seed | sha256sum | base64 | head -c 12)
  if [[ $pass =~ ^.*[0-9]+.*$ && $pass =~ ^.*[A-Z]+.*$  && $pass =~ ^.*[a-z]+.*$ ]];
     then loop=0
  fi
done
echo $pass
}

check_pass() {

pass=$1

for i in $PWD/password*.txt
 do cat $i >> temp.txt 
done


loop=1
check=0
while [[  $loop == 1 ]]; 
 do
 check=$(awk -v curr="$pass" '$1 ~ curr {print 1}' temp.txt)
 if [[ $check != 1 ]]; 
   then loop=0
   rm temp.txt
   else  pass=$(gen_pass)
 fi
done

echo $pass
}

pass=$(gen_pass)
name="password"
index=1
if [[ -e $name$index.txt ]]; 
   then
   pass=$(check_pass $pass)
   while [[ -e $name$index.txt ]];
      do
      let index++
    done
fi
name=$name$index

echo $pass > $name.txt



