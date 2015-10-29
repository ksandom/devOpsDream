# Library for DevOpsDream updater

function dodBuild
{ # Build DevOpsDream updater
	cd `getDODDockerDir`
	docker build -t devopsdreamupdater .
	commitToImage
}

function dodAddRepo
{
	cd `getDODDockerDir`
	
	repoName="$1"
	repoPath="$configDir/repos/$repoName"
	
	# Test that we have the repo
	if ! [ -e "$repoPath" ]; then
		echo "Could not find repo \"$repoName\" ($repoPath). The repo should already be installed using \"manangeAchel repoInstall\"." >&2
		exit 1
	fi
	
	docker run -tiv "$repoPath:/tmp/$repoName" devopsdreamupdater "addRepository" "$repoName"
	commitToImage
}

function dodDebug
{
	rootUser="$1"
	
	if [ "$rootUser" == 'true' ]; then
		docker run -it devopsdreamupdater 'bash'
	else
		docker run -it devopsdreamupdater su - devOpsDreamUpdater -c 'bash'
	fi
}

function dodRun
{
	docker run -it -v ~/.ssh:/home/devOpsDreamUpdater/.ssh -v ~/.aws:/home/devOpsDreamUpdater/.aws devopsdreamupdater su - devOpsDreamUpdater -c 'updaterService'
}

function dodClean
{
	containers=`docker ps -a | grep devopsdreamupdater | awk '{print $1}'`
	if [ "`echo $containers`" != '' ]; then
		echo "Removing containers"
		docker rm "$containers"
	else
		echo "No containers to remove."
	fi
	
	images=`docker images | grep devopsdreamupdater | awk '{print $3}'`
	if [ "`echo $images`" != '' ]; then
		echo "Removing images"
		docker rmi "$images"
	else
		echo "No images to remove"
	fi
}


function getDODDockerDir
{
	echo "$configDir/repos/devOpsDream/automation/Docker/DevOpsDreamUpdater"
}

function commitToImage
{
	latestID=`docker ps -a | awk '{print $1}' | tail -n+2 | head -n 1`
	docker commit "$latestID" devopsdreamupdater
	docker rm "$latestID"
}

function testForRepoExistance
{
	inputRepo="$1"
	if [ ! -e "$inputRepo" ]; then
		showHelp "Couild not find repo at \"$inputRepo\""
	fi
}
