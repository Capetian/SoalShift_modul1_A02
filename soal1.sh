#!/bin/bash


if [[ -e  nature.zip ]]; then
  unzip nature.zip
  mv nature temp
  mkdir nature
  for file in $PWD/temp/*.jpg
   do base64 -di $file | xxd -r > $PWD/nature/${file##*/}
  done
  rm -rf temp
  rm nature.zip
  zip nature.zip nature
  rm -rf nature
fi
