#!/bin/bash

# password 접속 허용
sudo sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
sudo service sshd restart

# sudo yum -y update
# sudo yum install -y java-1.8.0-openjdk-devel.x86_64
# rpm -qa java*jdk-devel
javac -version

sudo yum install -y python3
sudo python3 -m pip install --upgrade pip
sudo python3 -m pip install awscli

sudo yum -y install ruby
sudo yum -y install wget
cd /home/ec2-user
sudo wget https://aws-codedeploy-ap-northeast-2.s3.ap-northeast-2.amazonaws.com/latest/install

sudo chmod +x ./install
sudo ./install auto
sudo service codedeploy-agent start
sudo service codedeploy-agent status