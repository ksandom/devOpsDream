FROM debian:jessie
RUN apt-get update && apt-get install -y php5-cli git

ENV builton=2015-11-15
RUN mkdir -p /var/achelRepos;cd /var/achelRepos;git clone https://github.com/ksandom/achel.git;git clone https://github.com/ksandom/devOpsDream.git

# Install everything
ENV builton=2015-11-15
ADD internal/installStuff.sh /usr/sbin/installStuff
ADD internal/addRepository.sh /usr/bin/addRepository
RUN chmod 755 /usr/sbin/installStuff /usr/bin/addRepository
RUN /usr/sbin/installStuff

# Setup the service
CMD /bin/bash
