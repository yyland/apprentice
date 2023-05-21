FROM mysql:8.0-debian

RUN apt update && \
    apt install -y locales && \
    localedef -f UTF-8 -i ja_JP ja_JP.UTF-8 && \
    apt clean
ENV LANG=ja_JP.UTF-8
ENV TZ=Asia/Tokyo
WORKDIR /internet_tv