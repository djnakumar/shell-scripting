#!/bin/bash

source components/common.sh

print "installing nginx"
yum install nginx -y &>>$LOG_FILE
statcheck $?

print "downloading nginx content"
curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>$LOG_FILE
statcheck $?

print "cleanup old nginx content"
rm -rf /usr/share/nginx/html/* &>>$LOG_FILE
statcheck $?

cd /usr/share/nginx/html

print "extracting archive"
unzip /tmp/frontend.zip &>>$LOG_FILE && mv frontend-main/* . &>>$LOG_FILE && mv static/* . &>>$LOG_FILE
statcheck $?

print "update roboshop configuration"
mv localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG_FILE
sed -i -e '/catalogue/s/localhost/catalogue.roboshop.internal/' -e '/user/s/localhost/user.roboshop.internal/' -e '/cart/s/localhost/cart.roboshop.internal/' /etc/nginx/default.d/robo shop.conf
statcheck $?

print "starting nginx"
systemctl restart nginx &>>$LOG_FILE && systemctl enable nginx &>>$LOG_FILE
statcheck $?
