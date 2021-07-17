FROM ubuntu:latest
ENV DEBIAN_FRONTEND noninteractive
RUN apt update -qqy && \
  apt install -qqy mysql-client percona-toolkit && \
  apt -qqy  clean autoclean && \
  apt -qqy  autoremove && \
  rm -rf /var/lib/apt/lists/*
