#!/bin/bash
# Install the program
# Copyright (c) 2012, Kevin Sandom under the BSD License. See LICENSE for full details.

# If installed using the root user, the program will be available to all users. Otherwise it will be installed locally to the current user.
# Alternatively, if you install it as a non-root user, you can do a linked install like this:
# ./install.sh linked
#
# This is useful for development where you want to test changes without reinstalling.

# install.sh will get replaced eventually. For now it does what I need.

programName='mass'
fileThings='macros modules templates'
directoryThings='packages'
things="$fileThings $directoryThings"

function userInstall
{
	echo "Non root install chosen"
	configDir=~/.$programName
	bin="$configDir/bin"
	binExec=~/bin
	
	doInstall
}

function rootInstall
{
	echo "Root install chosen"
	configDir="/etc/$programName"
	bin="/usr/bin"
	binExec=/usr/bin
	installType='cp'
	
	doInstall
}

function checkPrereqs
{
	for prereq in php;do
		if ! which $prereq; then
			echo "Could not find $prereq in \$PATH" >&2
			exit 1
		fi
	done
}

function linkedInstall
{
	echo "Linked install chosen"
	configDir=~/.$programName
	bin="."
	binExec=~/bin
	installType='ln'
	
	if [ "`echo $PATH|grep $binExec`" == '' ]; then # A hack for the mac
		binExec=/usr/local/bin
	fi
	
	doInstall
}

function cleanEnabled
{
	testDir="$2"
	testFunction="$1"
	
	cd "$testDir"
	for item in *;do
		if ! $testFunction "$item"; then
			echo "$item is no longer present. Disabling."
			rm "$item"
		fi
		cd "$testDir"
	done
}

function testEnabledFile
{
	item="$1"
	cat "$item" 2>&1 > /dev/null
	return $?
}

function testEnabledDirectory
{
	item="$1"
	cd "$item" 2>&1 > /dev/null
	return $?
}

function createProfile
{
	name="$1"
	mkdir -p $configDir/profiles/$name/{packages,modules,macros,templates}
}

function enableEverythingForProfile
{
	name="$1"
	start=`pwd`
	for thing in $things; do
		cd $configDir/profiles/$name/$thing
		if [ `ls $configDir/$thing-available|wc -l 2> /dev/null` -gt 0 ]; then
			while read item;do
				if [ ! -e $item ]; then
					ln -s $configDir/$thing-available/$item .
				fi
			done < <(ls $configDir/$thing-available)
		fi
	done
	
	cd $start
}

function enableItemInProfile
{
	profile="$1"
	itemType="$2" # package,module,macro,template
	item="$3" # AWS,SSH
	
	cd $configDir/profiles/$profile/$itemType
	if [ -e $configDir/profiles/$profile/$itemType/$item ]; then
		ln -s $configDir/profiles/$profile/$itemType/$item .
	else
		echo "enableItemInProfile: Could not find $configDir/profiles/$profile/$itemType/$item" 1>&2
	fi
}

function disableItemInProfile
{
	profile="$1"
	itemType="$2" # package,module,macro,template
	item="$3" # AWS,SSH
	
	cd $configDir/profiles/$profile/$itemType
	if [ -e $configDir/profiles/$profile/$itemType/$item ]; then
		rm $configDir/profiles/$profile/$itemType/$item
	else
		echo "disableItemInProfile: Could not find $configDir/profiles/$profile/$itemType/$item" 1>&2
	fi
}

function cloneProfile
{
	from="$1"
	to="$2"
	
	cd $configDir/profiles
	rm -Rf "$to"
	cp -R "$from" "$to"
}

function cleanProfile
{
	name="$1"
	
	for thing in $fileThings;do
		cleanEnabled testEnabledFile "$configDir/profiles/$name/$thing"
	done
	
	for thing in $directoryThings;do
		cleanEnabled testEnabledDirectory "$configDir/profiles/$name/$thing"
	done
}


function doInstall
{
	startDir=`pwd` # for some reason ~- wasn't working
	mkdir -p "$configDir/data/hosts" "$binExec" "$bin"
	
	checkPrereqs
	
	echo "Install details:
	What: $programName
	Where:
		config: $configDir
		bin: $bin
		binExec: $binExec
		startDir: $startDir
		installType: $installType
		"
	
	if [ "$installType" == 'cp' ]; then
		echo -e "Copying available stuff"
		cp -Rv docs templates-* modules-* core.php macros-* packages-* examples interfaces index.php "$configDir"
		
		echo -e "Setting up remaining directory structure"
		cd "$configDir"
		mkdir -p config data/1LayerHosts
		
		echo -e "Making the thing runnable"
		cd $binExec
		cp -Rv "$startDir/$programName" "$bin"
		chmod 755 "$bin/$programName"
	else
		cd "$configDir"
		
		echo -e "Linking like there's no tomorrow."
		ln -sf "$startDir"/docs "$startDir"/modules-*available "$startDir"/macros-*available "$startDir"/templates-*available "$startDir/core.php" "$startDir/examples" "$startDir"/packages-*available "$startDir"/interfaces . 
		ln -sf "$startDir/index.php" .
		
		echo -e "Setting up remaining directory structure"
		mkdir -p config data/1LayerHosts
		
		echo -e "Making the thing runnable"
		cd $binExec
		ln -sf "$startDir/$programName" .
	fi
	
	createProfile commandLine
	enableEverythingForProfile commandLine
	cleanProfile commandLine

	createProfile privateWebAPI
	enableEverythingForProfile privateWebAPI
	disableItemInProfile privateWebAPI packages SSH
	cleanProfile privateWebAPI

	cloneProfile privateWebAPI publicWebAPI
	disableItemInProfile publicWebAPI packages AWS
	cleanProfile publicWebAPI
	
	echo -e "Cleanup"
	rm -f "$configDir/macros-enabled/example"*
	rm -f "$configDir/modules-enabled/example"
	rm -f "$configDir/templates-enabled/example"
	
	if [ ! -f "$configDir/config/Credentials.config.json" ];then
		echo -e "First time setup"
		mass --set=Credentials,defaultKey,id_rsa --saveStoreToConfig=Credentials
	fi
	
	# It should be safe to do this on an existing setup.
	echo -e "Detecting stuff"
	mass --createDefaultValues
	mass --detect=Terminal,seed,GUI --saveStoreToConfig=Terminal
}

if [ `id -u` -gt 0 ];then
	case $1 in
		'linked')
			linkedInstall
		;;
		*)
			echo "User install is broken at the moment and is low on my priorities to fix. Feel free to fix it."
			echo "In the mean time we'll use the linked install. You can install from another location by simply running $0 from that location at any time."
			echo
			echo "Alternatively you can comment out the linkedInstall and exit and roll the dice ;)"
			echo
			echo "Continuing with linked install."
			
			
			linkedInstall
			exit 1
			userInstall
		;;
	esac
else
	rootInstall
fi
 
