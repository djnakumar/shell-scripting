#!/bin/bash

DATE=$(date +%F)
echo date =$DATE

a=12
b=22
ADD=$(($a+$b))
echo ADD = $ADD



echo training =${TRAINING}


read -p 'enter ur name ' name

echo "your name $name"

echo a1 =$0
echo a2 =$1
echo all as =$*
echo no of a =$#
