#!/bin/bash

sleep 30

TOMCAT_DOWNLOAD_URL="https://mirror.navercorp.com/apache/tomcat/tomcat-9/v9.0.52/bin/apache-tomcat-9.0.52.tar.gz"
TOMCAT_TAR_GZ=$(echo "${TOMCAT_DOWNLOAD_URL}" | awk -F / '{print $9}')  # apache-tomcat-9.0.52.tar.gz
TOMCAT_NO_TAR=$(echo "${TOMCAT_TAR_GZ}" | awk -F . '{print $1"."$2"."$3}') # apache-tomcat-9.0.52

# update Package Manager
sudo yum -y update

sudo yum -y install wget

# 생성할 user의 id와 pw 기입
id='user'
pw='passw0rd1!'

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

# # Get Zulu-repo
# sudo yum install -y https://cdn.azul.com/zulu/bin/zulu-repo-1.0.0-1.noarch.rpm

# # Install zulu from yum repository
# sudo yum -y install zulu11-jdk

# OpenJDK 1.8 Download
sudo yum -y install java-1.8.0-openjdk-headless.x86_64

# Set up Environment variable to /etc/profile
TEMP_JAVA_HOME=$(readlink -f /usr/bin/java | awk -F'/bin' '{print $1}')

sudo bash -c 'cat >> /etc/profile' << EOF
# 1. Java Home
JAVA_HOME=$TEMP_JAVA_HOME

# 2. Catalina Home
CATALINA_HOME=/opt/tomcat

# 3. Binary
PATH=$PATH:$JAVA_HOME/bin

export JAVA_HOME CATALINA_HOME PATH
EOF

# sudo source /etc/profile
source <(sudo cat /etc/profile)

# Add Tomcat User & Group
sudo groupadd tomcat
sudo useradd -g tomcat tomcat

# Download Tomcat and Install
cd /usr/local/src
sudo wget $TOMCAT_DOWNLOAD_URL
sudo tar -zxvf $TOMCAT_TAR_GZ
sudo mv $TOMCAT_NO_TAR /opt/tomcat

# Change Permissions
cd /opt
sudo chmod -R 755 tomcat
sudo chown -R tomcat:tomcat tomcat

# Systemd unit file
sudo bash -c 'cat >> /usr/lib/systemd/system/tomcat.service' << EOF

[Unit]
Description=Apache Tomcat Web Application Container
After=syslog.target network.target

[Service]
Type=forking
User=tomcat
Group=tomcat
ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh
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