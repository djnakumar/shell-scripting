#!/bin/bash

source components/common.sh

print "configure yum repo"
curl -f -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>${LOG_FILE}
statcheck $?

print "install mysql"
yum install mysql-community-server -y &>>${LOG_FILE}
statcheck $?

print "Start MySQL service"
systemctl enable mysqld &>>${LOG_FILE} && systemctl start mysqld &>>${LOG_FILE}
statcheck $?

#
## grep temp /var/log/mysqld.log
#```
#
#1. Next, We need to change the default root password in order to start using the database service. Use password `RoboShop@1` or any other as per your choice. Rest of the options you can choose `No`
#
#```bash
## mysql_secure_installation
#```
#
#1. You can check the new password working or not using the following command in MySQL
#
#First lets connect to MySQL
#
#```bash
## mysql -uroot -pRoboShop@1
#```
#
#Once after login to MySQL prompt then run this SQL Command.
#
#```sql
#> uninstall plugin validate_password;
#```
#
### **Setup Needed for Application.**
#
#As per the architecture diagram, MySQL is needed by
#
#- Shipping Service
#
#So we need to load that schema into the database, So those applications will detect them and run accordingly.
#
#To download schema, Use the following command
#
#```bash
## curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"
#```
#
#Load the schema for Services.
#
#```bash
## cd /tmp
## unzip mysql.zip
## cd mysql-main
## mysql -u root -pRoboShop@1 <shipping.sq