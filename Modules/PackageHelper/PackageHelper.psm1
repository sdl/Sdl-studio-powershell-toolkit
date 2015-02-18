#######################################################################################################################
# File:             PackageHelper.psm1                                                                                #
# Author:           Patrik Mazanek                                                                                    #
# Publisher:        SDL                                                                                               #
# Copyright:        © 2011 SDL. All rights reserved.                                                                  #
# Usage:            To load this module in your Script Editor:                                                        #
#                   1. Open the Script Editor.                                                                        #
#                   2. Select "PowerShell Libraries" from the File menu.                                              #
#                   3. Check the PackageHelper module.                                                                #
#                   4. Click on OK to close the "PowerShell Libraries" dialog.                                        #
#                   Alternatively you can load the module from the embedded console by invoking this:                 #
#                       Import-Module -Name System.Object[]                                                           #
#                   Please provide feedback on the PowerGUI Forums.                                                   #
#######################################################################################################################

add-type -path 'C:\Program Files\SDL\SDL Trados Studio\Studio2\Sdl.ProjectAutomation.FileBased.dll';
add-type -path 'C:\Program Files\SDL\SDL Trados Studio\Studio2\Sdl.ProjectAutomation.Core.dll';

function New-Package
{
	param([Sdl.Core.Globalization.Language] $language,[String] $packagePath,
	[Sdl.ProjectAutomation.FileBased.FileBasedProject]$projectToProcess)
	
	$today = Get-Date;
	[Sdl.ProjectAutomation.Core.TaskFileInfo[]] $taskFiles =  Get-TaskFileInfoFiles $language $projectToProcess;
	[Sdl.ProjectAutomation.Core.ManualTask] $task = $projectToProcess.CreateManualTask("Translate", "API translator", $today +1 ,$taskFiles);
	[Sdl.ProjectAutomation.Core.ProjectPackageCreationOptions] $packageOptions = Get-PackageOptions
	[Sdl.ProjectAutomation.Core.ProjectPackageCreation] $package = $projectToProcess.CreateProjectPackage($task.Id, "mypackage",
                "A package created by the API", $packageOptions);
	$projectToProcess.SavePackageAs($package.PackageId, $packagePath);
}

function Get-PackageOptions
{
	[Sdl.ProjectAutomation.Core.ProjectPackageCreationOptions] $packageOptions = New-Object Sdl.ProjectAutomation.Core.ProjectPackageCreationOptions;
	$packageOptions.IncludeAutoSuggestDictionaries = $false;
	$packageOptions.IncludeMainTranslationMemories = $false;
    $packageOptions.IncludeTermbases = $false;
    $packageOptions.ProjectTranslationMemoryOptions = [Sdl.ProjectAutomation.Core.ProjectTranslationMemoryPackageOptions]::UseExisting;
    $packageOptions.RecomputeAnalysisStatistics = $false;
    $packageOptions.RemoveAutomatedTranslationProviders = $true;
    return $packageOptions;
}



Export-ModuleMember New-Package;



