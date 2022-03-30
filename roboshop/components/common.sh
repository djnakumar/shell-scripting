#!/bin/bash

statcheck() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[32msuccess\e[0m"
  else
    echo -e "\e[31msuccess\e[0m"
    exit 2
  fi
}

print() {
  echo -e "\n ........... $1 ........" &>>$LOG_FILE
  echo -e "\e[36m $1 \e[0m"
}
#not working

user_id=$(id -u)
if [ "$user_id" -ne 0 ]; then
  echo you should run your script as sudo or root user
  exit 1
fi
LOG_FILE=/tmp/roboshop.log
rm -f $LOG_FILE