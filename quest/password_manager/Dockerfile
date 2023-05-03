FROM ubuntu:22.04
RUN yes | unminimize
RUN apt-get update && \
    apt-get install -y locales vim less gpg
RUN locale-gen ja_JP.UTF-8
RUN mkdir -p /root/.gnupg && \
    echo "default-cache-ttl 5" > /root/.gnupg/gpg-agent.conf
ENV LANG=ja_JP.UTF-8
ENV TZ=Asia/Tokyo
WORKDIR /password-manager