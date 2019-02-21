#!/bin/bash

a=abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz
b=ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ

for file in $PWD/*; do
  case ${file##*/} in
    *[0-9][0-9][0-9][0-9].log )
     string=$(echo "$(cat "$PWD/${file##*/}")")
     name=${file##*/}
     name=${name:0:17}
     plus=${name:0:2}
     plus=$((26-${plus}))
     newstring=$(echo $string | tr "${a:0:26}" "${a:${plus}:26}")
     newstring=$(echo $newstring | tr "${b:0:26}" "${b:${plus}:26}")
     echo ${newstring} > "$name-dec.log"
     ;;
    * )  ;;
  esac
done
