<?php
# Copyright (c) 2012, Kevin Sandom under the BSD License. See LICENSE for full details.

# Manage mass packages

/* This is needed since most of the stuff in this module gets processed before the command line parameters can be processed to set the verbosity.
Set to 0 to show debugging.
Set to 4 normally.
*/
define('packageVerbosity', 0); 

class Packages extends Module
{
	private $loadedPackages=array();
	
	function __construct()
	{
		parent::__construct('Packages');
	}
	
	function event($event)
	{
		switch ($event)
		{
			case 'init':
				$this->loadEnabledPackages();
				break;
			case 'followup':
				break;
			case 'last':
				break;
			default:
				$this->core->complain($this, 'Unknown event', $event);
				break;
		}
	}
	
	function loadEnabledPackages()
	{
		$packageEnabledDir=$this->core->get('General', 'configDir').'/packages-enabled';
		$list=$this->core->getFileList($packageEnabledDir);
		foreach ($list as $filename)
		{
			# TODO The paths need to be taken into account so that enabled/avaiable will be able to co-exist without duplicates
			$this->core->debug(packageVerbosity, "loadEnabledPackages: $filename - loading");
			$this->loadPackage($filename);
		}
	}
	
	function loadPackage($packageName)
	{
		if (!isset($this->loadedPackages[$packageName]))
		{
			# TODO when the path is altered, this will need to be updated
			$packageParts=$this->core->getFileList($packageName);
			
			foreach ($packageParts as $filename=>$fullPath)
			{
				$this->loadComponent($filename, $fullPath);
			}
		}
		else
		{
			$this->core->debug(packageVerbosity, "loadPackage: $packageName is already loaded.");
		}
	}
	
	function loadComponent($filename, $fullPath)
	{
		if (is_file($fullPath))
		{
			#packageComponents
			$filenameParts=explode('.', $filename);
			$numParts=count($filenameParts);
			$lastPos=($numParts>1)?$numParts-1:0;
			
			/*
				private $packageComponents=array(
				'md'=>'Documentation',
				'php'=>'Module',
				'module'=>'Module',
				'macro'=>'Macro',
				'template'=>'Template',
				);
			*/
			
			switch ($filenameParts[$lastPos])
			{
				case 'md':
					$this->core->debug(packageVerbosity, "loadPackage: $filename Documentation should be in it's packages /doc folder.");
					break;
				case 'php':
				case 'module':
					$this->core->debug(packageVerbosity, "loadPackage: $filename Module. ($fullPath)");
					loadModules($this->core, $fullPath, false);
					break;
				case 'macro':
					$this->core->debug(packageVerbosity, "loadPackage: $filename Macro.");
					$this->core->addItemsToAnArray('Core', 'macrosToLoad', array($filename=>$fullPath));
					break;
				case 'template':
					$this->core->debug(packageVerbosity, "loadPackage: $filename Template.");
					break;
			}
			
			$this->core->debug(packageVerbosity, "loadEnabledPackages:   File $filename");
		}
		else
		{
			$this->core->debug(packageVerbosity, "loadEnabledPackages:   Not doing anything with directories yet $filename");
		}
		
	}
}

$core=core::assert();
$core->registerModule(new Packages());
 
?>