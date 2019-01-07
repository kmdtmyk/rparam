FROM ruby:2.5.3

RUN apt-get update && \
    apt-get install -y \
    vim \
    sudo

ARG uid
ARG gid

# add user
RUN groupadd -g $gid docker && \
    useradd -u $uid -g docker -G sudo -m -s /bin/bash docker && \
    echo 'docker:docker' | chpasswd

USER docker
