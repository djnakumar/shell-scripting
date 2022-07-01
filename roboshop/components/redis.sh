#!/bin/bash

source components/common.sh

print "setup yum repos"
curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>>${LOG_FILE}
statcheck $?

print "install redis"
yum install redis -y &>>${LOG_FILE}
statcheck $?

print "update redis config"
if [ -f /etc/redis.conf ]; then
  sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf
fi
if [ -f /etc/redis.conf ]; then
  sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf
fi
statcheck $?


print "start redis service"
systemctl enable redis &>>${LOG_FILE} && systemctl start redis &>>${LOG_FILE}
statcheck $?
