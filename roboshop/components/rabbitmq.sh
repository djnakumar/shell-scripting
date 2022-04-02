#!/bin/bash

source components/common.sh

print "configure yum repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>${LOG_FILE}
statcheck $?

print "install erlang & rabbitmq"
yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm rabbitmq-server -y &>>${LOG_FILE}
statcheck $?

print "Start RabbitMQ service"
systemctl enable rabbitmq-server &>>${LOG_FILE} && systemctl start rabbitmq-server &>>${LOG_FILE}
statcheck $?

rabbitmqctl list_users | grep roboshop &>>${LOG_FILE}
if [ $? -ne 0 ]; then
  print "create application user"
  rabbitmqctl add_user roboshop roboshop123 &>>${LOG_FILE}
  statcheck $?
fi
print "configure application user"
rabbitmqctl set_user_tags roboshop administrator && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
statcheck $?
