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

# Install achel
cd /var/achelRepos/achel
chmod 755 /var/achelRepos/achel/install.sh
su -c /var/achelRepos/achel/install.sh devOpsDreamUpdater

# Install devOpsDream
manageAchel repoInstall /var/achelRepos/devOpsDream

# TODO Install custom repo

