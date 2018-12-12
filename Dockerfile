FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive
ENV DOCKERIZE_VERSION "v0.6.1"
ENV GOSU_VERSION "1.10"
ENV SHELL /bin/bash
ENV TINI_VERSION "v0.18.0"

RUN apt-get update

RUN apt-get dist-upgrade --assume-yes

RUN apt-get install --assume-yes --no-install-recommends --no-install-suggests \
    apt-transport-https \
    apt-utils \
    ca-certificates \
    curl \
    git \
    gnupg2 \
    groff \
    language-pack-en \
    python \
    python-pip \
    ssh \
    sudo \
    tmux \
    unzip \
    zip

RUN update-locale

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN apt-get purge --assume-yes --auto-remove \
    --option APT::AutoRemove::RecommendsImportant=false \
    --option APT::AutoRemove::SuggestsImportant=false
RUN rm -rf /var/lib/apt/lists/*


ENV PYTHONIOENCODING=UTF-8

RUN pip install --upgrade pip==9.0.3
RUN pip install setuptools
RUN pip install awscli

RUN curl -LS https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_VERSION}/dockerize-linux-amd64-${DOCKERIZE_VERSION}.tar.gz \
    | tar xzv -C /usr/local/bin

RUN curl -LS https://gist.githubusercontent.com/zyedidia/d4acfcc6acf2d0d75e79004fa5feaf24/raw/a43e603e62205e1074775d756ef98c3fc77f6f8d/install_micro.sh \
    | bash -s linux64 /usr/local/bin

ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/local/bin/tini

ADD https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64 /usr/local/bin/gosu

COPY bin/idmod /usr/local/bin/idmod

RUN chown root:root /usr/local/bin/*
RUN chmod 755 /usr/local/bin/*

COPY etc/bash.bashrc /etc/bash.bashrc
COPY etc/ssh/ssh_config /etc/ssh/ssh_config
COPY etc/sudoers /etc/sudoers
RUN chmod 440 /etc/sudoers
