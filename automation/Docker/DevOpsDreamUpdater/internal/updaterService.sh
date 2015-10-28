#!/bin/bash

intervalSeconds=600
verbosity=1

set -x

git config --global user.email "you@example.com"
git config --global user.name "devOpsDreamUpdater service"
git config --global push.default matching

while true;do
	cd ~/.achel/repos
	for repo in *;do
		cd ~/".achel/repos/$repo"
		git stash # TODO ditch any uncommitted changes, rather than stash
		git pull
	done
	
	d -v --awsGetAll
	
	cd ~/.achel/repos
	for repo in *;do
		cd ~/".achel/repos/$repo"
		git add .
		git commit -m 'devOpsDreamUpdater: Data commit.'
		git pull
		git push
	done
	
	echo "Sleeping for $intervalSeconds seconds before next update."
	sleep $intervalSeconds
done
