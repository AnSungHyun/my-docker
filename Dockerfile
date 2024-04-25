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
    && yum clean all

# rbenv 설치
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv && \
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc && \
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc

# ruby-build 플러그인 설치
RUN git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

# JDK 1.8.0_402 설치
RUN yum install -y java-1.8.0-openjdk-devel

# Ruby 1.9.3-p551 설치
RUN rbenv install 1.9.3-p551 && \
    rbenv global 1.9.3-p551

# Sencha Cmd 5.0.0.160 설치
RUN curl -o /tmp/SenchaCmd-5.0.0.160-linux-x64.run.zip https://cdn.sencha.com/cmd/5.0.0.160/SenchaCmd-5.0.0.160-linux-x64.run.zip && \
    unzip /tmp/SenchaCmd-5.0.0.160-linux-x64.run.zip -d /tmp && \
    chmod +x /tmp/SenchaCmd-5.0.0.160-linux-x64.run && \
    echo -e '\n\n\n\n\n\ny\n/opt\n\n' | /tmp/SenchaCmd-5.0.0.160-linux-x64.run && \
    rm -f /tmp/SenchaCmd-5.0.0.160-linux-x64.run.zip

# 환경변수 설정
ENV PATH="/opt/Sencha/Cmd/5.0.0.160:${PATH}"

# 작업 디렉토리 설정
WORKDIR /app

# Docker 컨테이너 실행 시 자동으로 sencha build 명령어 실행
CMD ["sencha", "app", "build"]