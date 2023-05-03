FROM ubuntu:22.04
RUN yes | unminimize
RUN apt-get update && \
    apt-get install -y locales vim less
RUN locale-gen ja_JP.UTF-8
ENV LANG=ja_JP.UTF-8
ENV TZ=Asia/Tokyo
WORKDIR /password-manager