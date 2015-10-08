#!/bin/bash

# Needs to know
	# TODO What extra repos to clone
	# TODO Credentials 
		# TODO github
		# TODO aws

# Get achel - Currently achieved in the docker file
# Get devOpsDream - Currently achieved in the docker file

# Create user
useradd -m devOpsDreamUpdater -s /bin/bash
mkdir ~devOpsDreamUpdater/bin
chown -R devOpsDreamUpdater ~devOpsDreamUpdater/bin

# Install achel
cd /var/achelRepos/achel
chmod 755 /var/achelRepos/achel/install.sh
su - devOpsDreamUpdater -c /var/achelRepos/achel/install.sh

# Install devOpsDream
su - devOpsDreamUpdater -c "manageAchel repoInstall /var/achelRepos/devOpsDream"

su - devOpsDreamUpdater -c "d --unitTests"
# TODO Install custom repo

