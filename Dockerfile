# Dockerfile

# 베이스 이미지 설정
FROM centos:7

# 필수 패키지 설치
RUN yum install -y \
    git \
    curl \
    zlib-devel \
    openssl-devel \
    readline-devel \
    gcc \
    make \
    tar \
    unzip \
    bzip2 \
    && yum clean all

# Timezone 설정
ENV TZ=Asia/Seoul

# 새로운 사용자 생성
ARG USERNAME=jenkins
ARG USER_UID=1003
RUN groupadd --gid $USER_UID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_UID --create-home --shell /bin/bash $USERNAME

# rbenv 설치
RUN git clone https://github.com/rbenv/rbenv.git /usr/local/rbenv && \
    echo 'export RBENV_ROOT="/usr/local/rbenv"' >> /etc/profile && \
    echo 'export PATH="/usr/local/rbenv/bin:$PATH"' >> /etc/profile && \
    echo 'eval "$(rbenv init -)"' >> /etc/profile && \
    source /etc/profile

# ruby-build 플러그인 설치
RUN git clone https://github.com/rbenv/ruby-build.git /usr/local/rbenv/plugins/ruby-build

# JDK 1.8.0_402 설치
# RUN yum install -y java-1.8.0-openjdk-devel
# openjdk RPM 다운로드 및 설치
RUN curl -o openjdk.rpm https://builds.openlogic.com/downloadJDK/openlogic-openjdk/8u402-b06/openlogic-openjdk-8u402-b06-linux-x64-el.rpm && \
    yum install -y openjdk.rpm && \
    rm openjdk.rpm

# Ruby 1.9.3-p551 설치
RUN /bin/bash -c "source /etc/profile && rbenv install 1.9.3-p551 && rbenv global 1.9.3-p551"

# Sencha Cmd 5.0.0.160 설치
RUN curl -o /tmp/SenchaCmd-5.0.0.160-linux-x64.run.zip https://cdn.sencha.com/cmd/5.0.0.160/SenchaCmd-5.0.0.160-linux-x64.run.zip && \
    unzip /tmp/SenchaCmd-5.0.0.160-linux-x64.run.zip -d /tmp && \
    chmod +x /tmp/SenchaCmd-5.0.0.160-linux-x64.run && \
    echo -e '\n\n\n\n\n\ny\n/opt\n\n' | /tmp/SenchaCmd-5.0.0.160-linux-x64.run && \
    rm -f /tmp/SenchaCmd-5.0.0.160-linux-x64.run.zip

# Sencha Cmd 설치 경로 소유자 변경
RUN chown -R jenkins:jenkins /opt/Sencha

# Sencha Cmd 설치 경로
ENV SENCHA_CMD_PATH="/opt/Sencha/Cmd/5.0.0.160"
ENV SENCHA_CMD_3_0_0="/opt/Sencha/Cmd/5.0.0.160"

# 대상 파일 경로
ENV FILE_PATH="${SENCHA_CMD_PATH}/sencha.cfg"

# 대체할 문자열
ENV SEARCH_STRING="-Xms128m -Xmx1024m"
ENV REPLACE_STRING="-Xms512m -Xmx4096m"

# 파일 내의 모든 문자열 치환
RUN sed -i "s/${SEARCH_STRING}/${REPLACE_STRING}/g" "${FILE_PATH}"

# 환경변수 설정
ENV PATH="/usr/local/rbenv/bin:/usr/local/rbenv/versions/1.9.3-p551/bin:/opt/Sencha/Cmd/5.0.0.160:${PATH}"

# 작업 디렉토리 설정
WORKDIR /app

# Docker 컨테이너 실행 시 자동으로 sencha build 명령어 실행
# CMD ["sencha"]
