FROM debian:jessie
RUN apt-get update && apt-get install -y php5-cli git python-pip
RUN pip install awscli

ENV builton=2015-10-29
RUN mkdir -p /var/achelRepos;cd /var/achelRepos;git clone https://github.com/ksandom/achel.git;git clone https://github.com/ksandom/devOpsDream.git; git clone https://github.com/nevik/gitwatch.git

# Install everything
ENV builton=2015-10-30
ADD internal/installStuff.sh /usr/sbin/installStuff
ADD internal/updaterService.sh /usr/bin/updaterService
ADD internal/addRepository.sh /usr/bin/addRepository
RUN chmod 755 /usr/sbin/installStuff /usr/bin/updaterService /usr/bin/addRepository
RUN /usr/sbin/installStuff

# Setup the service
CMD updaterService
