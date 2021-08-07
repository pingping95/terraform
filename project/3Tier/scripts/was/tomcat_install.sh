#!/bin/bash

TOMCAT_DOWNLOAD_URL="https://mirror.navercorp.com/apache/tomcat/tomcat-9/v9.0.50/bin/apache-tomcat-9.0.50.tar.gz"

# update Package Manager
sudo yum -y update

# 생성할 user의 id와 pw 기입
id='user'
pw='passw0rd'

# User 생성
# User 없을 시 아래 if문을 실행하지 않음
if [ -n "$id" ] && [ -n "$pw" ]; then
  sudo useradd $id
  sudo bash -c "echo '$id:$pw' | chpasswd"
  sudo usermod -aG wheel $id
fi

# Timezone 변경
sudo rm -rf /etc/localtime
sudo ln -s /usr/share/zoneinfo/Asia/Seoul /etc/localtime


# password 접속 허용
sudo sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
sudo service sshd restart

# 1. Install Openjdk (Zulu)

# Get Zulu-repo
sudo yum install -y https://cdn.azul.com/zulu/bin/zulu-repo-1.0.0-1.noarch.rpm

# Install zulu from yum repository
sudo yum -y install zulu11-jdk

# Set up Environment variable to /etc/profile

sudo bash -c 'cat >> /etc/profile' << EOF
# 1. Java Home
JAVA_HOME=/usr/lib/jvm/zulu11

# 2. Catalina Home
CATALINA_HOME=/usr/local/tomcat

# 3. Binary
PATH=$PATH:/usr/lib/jvm/zulu11/bin

export JAVA_HOME CATALINA_HOME PATH
EOF

sudo source /etc/profile

# Add Tomcat User & Group
sudo groupadd tomcat
sudo useradd -g tomcat tomcat

# Download Tomcat and Install
cd /usr/local/src
sudo wget $TOMCAT_DOWNLOAD_URL
sudo tar -zxvf apache-tomcat-9.0.50.tar.gz
sudo mv apache-tomcat-9.0.50/ /usr/local/tomcat/

# Change Permissions
cd /usr/local
sudo chmod -R 755 tomcat
sudo chown -R tomcat:tomcat tomcat

id='tomcat'
pw='passw0rd'

sudo bash -c "echo '$id:$pw' | chpasswd"
sudo usermod -aG wheel $id

# Systemd unit file
sudo bash -c 'cat >> /usr/lib/systemd/system/tomcat.service' << EOF

[Unit]
Description=Apache Tomcat Web Application Container
After=syslog.target network.target

[Service]
Type=forking
User=tomcat
Group=tomcat
ExecStart=/usr/local/tomcat/bin/startup.sh
ExecStop=/usr/local/tomcat/bin/shutdown.sh
# SuccessExitStatus=143
Restart=always
RestartSec=10
UMask=0007

[Install]
WantedBy=multi-user.target

EOF

# Tomcat Service enable & Start
sleep 1

sudo systemctl daemon-reload

sudo systemctl restart tomcat

sudo systemctl enable tomcat