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
  echo -e "\n ............................... $1 ............................"
  echo -e "\e[36m $1 \e[0m"
}

user_id=$(id -u)
if [ "$user_id" -ne 0 ]; then
  echo you should run your script as sudo or root user
  exit 1
fi
LOG_FILE=/tmp/roboshop.log
rm -f $LOG_FILE

print "installing nginx"
yum install nginx -y >>$LOG_FILE
statcheck $?

print "downloading nginx content"
curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" >>$LOG_FILE
statcheck $?

print "cleanup old nginx content"
rm -rf /usr/share/nginx/html/* >>$LOG_FILE
statcheck $?

cd /usr/share/nginx/html

print "extracting archive"
unzip /tmp/frontend.zip >>$LOG_FILE && mv frontend-main/* >>$LOG_FILE . && mv static/* . >>$LOG_FILE
statcheck $?

print "update roboshop configuration"
mv localhost.conf /etc/nginx/default.d/roboshop.conf >>$LOG_FILE
statcheck $?

print "starting nginx"
systemctl restart nginx >>$LOG_FILE && systemctl enable nginx >>$LOG_FILE
statcheck $?
