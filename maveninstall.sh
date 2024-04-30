#!/bin/bash

# JDK 8u402-b06 설치
curl -o openjdk.rpm https://builds.openlogic.com/downloadJDK/openlogic-openjdk/8u402-b06/openlogic-openjdk-8u402-b06-linux-x64-el.rpm && \
    yum install -y openjdk.rpm && \
    rm openjdk.rpm

# 다운로드 및 설치할 Maven 버전 및 URL
MAVEN_VERSION="3.6.3"
MAVEN_URL="https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz"

# 설치 디렉토리
INSTALL_DIR="/usr/local/maven"

# Maven 다운로드 및 압축 해제
mkdir -p ${INSTALL_DIR}
curl -fsSL ${MAVEN_URL} -o /tmp/apache-maven.tar.gz
tar -xzf /tmp/apache-maven.tar.gz -C ${INSTALL_DIR} --strip-components=1
rm -f /tmp/apache-maven.tar.gz

# Maven 환경 변수 설정
echo "export MAVEN_HOME=${INSTALL_DIR}" >> /etc/profile
echo "export PATH=\$PATH:\$MAVEN_HOME/bin" >> /etc/profile

# 환경 변수 적용
source /etc/profile

echo "Maven ${MAVEN_VERSION} 설치가 완료되었습니다."
