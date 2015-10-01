FROM debian:jessie
RUN apt-get update && apt-get install -y php5-cli git python-pip
RUN pip install awscli

ENV builton=2015-08-26
RUN mkdir -p /var/achelRepos;cd /var/achelRepos;git clone https://github.com/ksandom/achel.git;git clone https://github.com/ksandom/devOpsDream.git; git clone https://github.com/nevik/gitwatch.git

# Install everything
ENV builton=2015-10-01
ADD installStuff.sh /usr/sbin/installStuff
ADD updaterService.sh /usr/sbin/updaterService
RUN chmod 755 /usr/sbin/installStuff /usr/sbin/updaterService
RUN /usr/sbin/installStuff
RUN d --unitTests

# Setup the service
CMD updaterService
