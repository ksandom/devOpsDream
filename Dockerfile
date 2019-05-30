FROM ubuntu

# Install the bare minimum to function.
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y php7.2-cli php7.2-curl curl git wget
# TODO finish timezone config

# Install the luxury packages that will bring us the fun functionality.
RUN apt install -y screen xterm clusterssh

# Install devOpsDream
RUN export extraSrc="https://github.com/ksandom/devOpsDream.git"; curl https://raw.githubusercontent.com/ksandom/achel/master/supplimentary/misc/webInstall | bash

# Install stuff for AWS
RUN apt install -y python3-pip && pip3 install awscli

# Install stuff for chef
ENV RUBY_VERSION=2.5.1
ENV PATH=$PATH:/root/.rbenv/bin:/root/.rbenv/shims
RUN apt-get install -y libssl-dev libreadline-dev zlib1g-dev
RUN wget -q https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer -O- | bash && \
    rbenv install --list && rbenv install $RUBY_VERSION && \
    rbenv global $RUBY_VERSION && \
    rbenv rehash && \
    eval "$(rbenv init -)"
RUN gem install chef && gem install chef
