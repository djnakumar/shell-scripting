#!/bin/bash

DATE=$(date +%F)
echo date =$DATE

a=12
b=22
ADD=$(($a+$b))
echo ADD = $ADD



echo training =${TRAINING}


read -p 'name ' name

eco "your name $name"