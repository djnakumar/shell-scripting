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

APP_USER=roboshop

NODEJS() {
  print "configure yum repos"
  curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash - &>>${LOG_FILE}
  statcheck $?

  print "install nodejs"
  yum install nodejs gcc-c++ -y &>>${LOG_FILE}
  statcheck $?

  print "add aplication user"
  id ${APP_USER} &>>${LOG_FILE}
  if [ $? -ne 0 ]; then
    useradd ${APP_USER} &>>${LOG_FILE}
  fi
  statcheck $?

  print "download app component"
  curl -f -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>${LOG_FILE}
  statcheck $?

  print "cleanup old content"
  rm -rf /home/${APP_USER}/${COMPONENT} &>>${LOG_FILE}
  statcheck $?

  print "extract app content"
  cd /home/${APP_USER} &>>${LOG_FILE} && unzip -o /tmp/${COMPONENT}.zip &>>${LOG_FILE} && mv ${COMPONENT}-main ${COMPONENT} &>>${LOG_FILE}
  statcheck $?

  print "install app dependencies"
  cd /home/${APP_USER}/${COMPONENT} &>>${LOG_FILE} && npm install &>>${LOG_FILE}
  statcheck $?

  print "fix app user permissions"
  chown -R ${APP_USER}:${APP_USER} /home/${APP_USER}
  statcheck $?

  print "setup systemd file"
  sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal' -e 's/MONGODB_ENDPOINT/mongodb.roboshop.internal' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal'  /home/roboshop/${COMPONENT}/systemd.service &>>${LOG_FILE} && mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>>${LOG_FILE}
  statcheck $?

  print "restart catalogue services"
  systemctl daemon-reload &>>${LOG_FILE} && systemctl restart ${COMPONENT} &>>${LOG_FILE} && systemctl enable ${COMPONENT} &>>${LOG_FILE}
  statcheck $?


}