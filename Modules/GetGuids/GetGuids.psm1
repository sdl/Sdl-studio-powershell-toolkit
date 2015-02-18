#######################################################################################################################
# File:             GetGuids.psm1                                                                                     #
# Author:           Patrik Mazanek                                                                                    #
# Publisher:        SDL                                                                                               #
# Copyright:        © 2011 SDL. All rights reserved.                                                                  #
# Usage:            To load this module in your Script Editor:                                                        #
#                   1. Open the Script Editor.                                                                        #
#                   2. Select "PowerShell Libraries" from the File menu.                                              #
#                   3. Check the GetGuids module.                                                                     #
#                   4. Click on OK to close the "PowerShell Libraries" dialog.                                        #
#                   Alternatively you can load the module from the embedded console by invoking this:                 #
#                       Import-Module -Name System.Object[]                                                           #
#                   Please provide feedback on the PowerGUI Forums.                                                   #
#######################################################################################################################

function Get-Guids
{
	param([Sdl.ProjectAutomation.Core.ProjectFile[]] $files)
	[System.Guid[]] $guids = New-Object System.Guid[] ($files.Count);
	$i = 0;
	foreach($file in $files)
	{
		$guids.Set($i,$file.Id);
		$i++;
	}
	return $guids
}
 
Export-ModuleMember Get-Guids 

