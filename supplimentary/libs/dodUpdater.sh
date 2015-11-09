# Library for DevOpsDream updater

function dodBuild
{ # Build DevOpsDream updater
	cd `getDODUpdaterDockerDir`
	docker build -t devopsdreamupdater .
}

function dodGenericBuildLocal
{
	tmpDir="/tmp/dodab-$$"
	buildTypeUpper="$1"
	buildTypeLower="$2"
	
	mkdir "$tmpDir"
	cp -R `getDOD${buildTypeUpper}DockerDir`/* $tmpDir
	cd "$tmpDir"
	
	cp Dockerfile.local Dockerfile
	
	mkdir achelRepos
	cp -R --dereference "$configDir/repos/achel" "$configDir/repos/devOpsDream" achelRepos
	
	docker build -t devopsdream${buildTypeLower} .
	
	rm -Rf "$tmpDir"
}

function dodUpdaterBuildLocal
{ # Build DevOpsDream updater with the current copies of the repos rather than downloading them. This is useful for testing new 
	dodGenericBuildLocal Updater updater
}

function dodClientBuildLocal
{ # Build DevOpsDream client with the current copies of the repos rather than downloading them. This is useful for testing new 
	dodGenericBuildLocal Client client
}

function dodAddRepo
{
	cd `getDODUpdaterDockerDir`
	
	repoName="$1"
	repoPath="$configDir/repos/$repoName"
	buildTypeLower="$2"
	
	# Test that we have the repo
	if ! [ -e "$repoPath" ]; then
		echo "Could not find repo \"$repoName\" ($repoPath). The repo should already be installed using \"manangeAchel repoInstall\"." >&2
		exit 1
	fi
	
	docker run -tiv "$repoPath:/tmp/$repoName" devopsdream${buildTypeLower} "addRepository" "$repoName"
	commitToImage
}

function dodDebug
{
	rootUser="$1"
	buildTypeUpper="$2"
	buildTypeLower="$3"
	
	
	if [ "$rootUser" == 'true' ]; then
		docker run -it devopsdream${buildTypeLower} 'bash'
	else
		docker run -it devopsdream${buildTypeLower} su - devOpsDream{$buildTypeLower} -c 'bash'
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
		docker rm $containers
	else
		echo "No containers to remove."
	fi
	
	images=`docker images | grep devopsdreamupdater | awk '{print $3}'`
	if [ "`echo $images`" != '' ]; then
		echo "Removing images"
		docker rmi $images
	else
		echo "No images to remove"
	fi
}


function getDODUpdaterDockerDir
{
	echo "$configDir/repos/devOpsDream/automation/Docker/DevOpsDreamUpdater"
}

function getDODClientDockerDir
{
	echo "$configDir/repos/devOpsDream/automation/Docker/DevOpsDreamClient"
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
