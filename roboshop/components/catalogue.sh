#!/bin/bash

source components/common.sh

print "configure yum repos"
curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash - &>>${LOG_FILE}
statcheck $?

print "install nodejs"
yum install nodejs gcc-c++ -y &>>${LOG_FILE}
statcheck $?

print "add aplication user"
id ${APP_USER} &>>${LOG_FILE}
if [ $? -ne 0 ]; then
  useradd $(APP_USER) &>>${LOG_FILE}
fi
statcheck $?

print "download app component"
curl -f -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>${LOG_FILE}
statcheck $?

print "cleanup old content"
rm -rf /home/${APP_USER}/catalogue &>>${LOG_FILE}
statcheck $?

print "extract app content"
cd /home/${APP_USER} &>>${LOG_FILE} && unzip -o /tmp/catalogue.zip &>>${LOG_FILE} && mv catalogue-main catalogue &>>${LOG_FILE}
statcheck $?

print "install app dependencies"
cd /home/${APP_USER}/catalogue &>>${LOG_FILE} && npm install &>>${LOG_FILE}
statcheck $?

print "fix app user permissions"
chown -R ${APP_USER}:${APP_USER} /home/${APP_USER}
statcheck $?

print "setup systemd file"
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/roboshop/catalogue/systemd.service &>>${LOG_FILE} && mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>${LOG_FILE}
statcheck $?

print "restart catalogue services"
systemctl daemon-reload &>>${LOG_FILE} && systemctl restart catalogue &>>${LOG_FILE} && systemctl enable catalogue &>>${LOG_FILE}
statcheck $?

