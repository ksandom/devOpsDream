FROM kjsandom/achel

# Install the luxury packages that will bring us the fun functionality.
RUN apt update && apt install -y screen xterm clusterssh

# Install stuff for AWS
RUN apt update && apt install -y python3-pip && pip3 install awscli

# Install stuff for chef
# NOTE Disabled inbuilt Chef stuff for now. I need to understand it way better before I try this again. You can still create images based on this image and install it for your needs.
# ENV RUBY_VERSION=2.5.1
# ENV PATH=$PATH:/root/.rbenv/bin:/root/.rbenv/shims
# RUN apt-get install -y libssl-dev libreadline-dev zlib1g-dev
# RUN wget -q https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer -O- | bash && \
#     rbenv install --list && rbenv install $RUBY_VERSION && \
#     rbenv global $RUBY_VERSION && \
#     rbenv rehash && \
#     eval "$(rbenv init -)"
# RUN gem install chef && gem install chef

# Install devOpsDream
ADD . /usr/installs/devOpsDream
RUN cd /usr/installs/devOpsDream && \
  /usr/installs/achel/automation/dockerInternal/preInstall && \
  achelctl repoInstall `pwd` && \
  /usr/installs/achel/automation/dockerInternal/postInstall
