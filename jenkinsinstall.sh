#!/bin/bash

# Jenkins 버전 및 URL
JENKINS_VERSION="2.164.1"
JENKINS_URL="https://get.jenkins.io/war-stable/${JENKINS_VERSION}/jenkins.war"

# Jenkins Home 디렉토리
JENKINS_HOME="/var/lib/jenkins"

# Jenkins 사용자 생성 및 패스워드 설정
sudo useradd --system --home $JENKINS_HOME --shell /bin/bash jenkins
echo "jenkins:Asdf1234" | sudo chpasswd

# Jenkins 설치 디렉토리 및 war 파일 다운로드
JENKINS_INSTALL_DIR="/opt/jenkins"
sudo mkdir -p $JENKINS_INSTALL_DIR
sudo curl -fsSL $JENKINS_URL -o $JENKINS_INSTALL_DIR/jenkins.war

# Jenkins 실행을 위한 systemd 서비스 파일 생성
sudo tee /etc/systemd/system/jenkins.service > /dev/null <<EOF
[Unit]
Description=Jenkins Service
After=network.target

[Service]
User=jenkins
ExecStart=/usr/bin/java -jar $JENKINS_INSTALL_DIR/jenkins.war --httpPort=8080
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Jenkins Home 디렉토리 권한 설정
sudo chown -R jenkins:jenkins $JENKINS_HOME

# 서비스 시작 및 활성화
sudo systemctl daemon-reload
sudo systemctl start jenkins
sudo systemctl enable jenkins
