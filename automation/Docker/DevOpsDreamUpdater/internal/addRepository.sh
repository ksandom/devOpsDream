#!/bin/bash
# The internal side to installing a repository

repoName="$1"

# copy repo from /tmp
cp -R "/tmp/$repoName" /var/achelRepos

# change ownership
chown -R devOpsDreamUpdater "/var/achelRepos/$repoName"

# repoInstall
su - devOpsDreamUpdater -c "achelctl repoInstall \"/var/achelRepos/$repoName\"; d --unitTests"
