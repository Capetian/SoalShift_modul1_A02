#!/bin/bash


if [[ -e  nature.zip ]]; then
  unzip nature.zip
  mv nature temp
  mkdir nature
  for file in ~/Desktop/temp/*.jpg
   do base64 -di $file | xxd -r > ~/Desktop/nature/${file##*/}
  done
  rm -rf temp
fi
