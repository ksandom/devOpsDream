#!/bin/bash

intervalSeconds=600
verbosity=1

echo "Setting git config"
git config --global user.email "you@example.com"
git config --global user.name "devOpsDreamUpdater service"
git config --global push.default matching

while true;do
	cd ~/.achel/repos
	repos=`find */.git/config -maxdepth 1 -user \`whoami\` | cut -d/ -f 1`
	for repo in $repos;do
		cd ~/".achel/repos/$repo"
		echo "Pulling $repo."
		git stash # TODO ditch any uncommitted changes, rather than stash
		git pull
	done
	
	echo "Getting everything."
	d -v --awsGetAll
	
	cd ~/.achel/repos
	for repo in $repos;do
		cd ~/".achel/repos/$repo"
		echo "Commiting and changes to $repo."
		git add .
		git commit -m 'devOpsDreamUpdater: Data commit.'
		git pull
		git push
	done
	
	echo "Sleeping for $intervalSeconds seconds before next update."
	sleep $intervalSeconds
done
