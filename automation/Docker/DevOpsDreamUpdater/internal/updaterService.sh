#!/bin/bash

intervalSeconds=600
verbosity=1

set -e

cd ~/.achel/data
while true;do
	git stash # TODO ditch the uncommitted changes, rather than stash
	git pull
	d --awsGetAll
	git add .
	git commit -m 'devOpsDreamUpdater: Data commit.'
	git push
	echo "Sleeping for $intervalSeconds seconds before next update."
	sleep $intervalSeconds
done
