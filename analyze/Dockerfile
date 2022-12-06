FROM ubuntu:latest
ENV DEBIAN_FRONTEND noninteractive
RUN apt update -qqy && \
  apt install -qqy mysql-client percona-toolkit curl unzip git && \
  apt -qqy  clean autoclean && \
  apt -qqy  autoremove && \
  rm -rf /var/lib/apt/lists/*
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install
COPY ./enable_query_log.sh /
COPY ./analyze.sh /
ENTRYPOINT ["/analyze.sh"]
