# Stuff for building and extending the devOpsDreamUpdater image

function commitToImage
{
	latestID=`docker ps -a | awk '{print $1}' | tail -n+2 | head -n 1`
	docker commit "$latestID" devopsdreamupdater
	docker rm "$latestID"
}

function showHelp
{
	message="$1"
	if [ "$message" != '' ]; then
		echo -e "$message\n" >&2
	fi
	
	name=`echo $0|sed 's#.*/##g'`
	grep '^# ' $0 | sed 's/$0/'$name'/g;s/^# //g' >&2
	exit 1
}

function testForParameters
{
	if [ "$1" == '' ] || [ "$1" == '--help' ]; then
		showHelp "No prarameters supplied."
	fi
}


function testForRepoExistance
{
	inputRepo="$1"
	if [ ! -e "$inputRepo" ]; then
		showHelp "Couild not find repo at \"$inputRepo\""
	fi
}
