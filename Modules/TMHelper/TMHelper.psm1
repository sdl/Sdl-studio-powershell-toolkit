#######################################################################################################################
# File:             TMHelper.psm1                                                                                     #
# Author:           Patrik Mazanek                                                                                    #
# Publisher:        SDL                                                                                               #
# Copyright:        © 2011 SDL. All rights reserved.                                                                  #
# Usage:            To load this module in your Script Editor:                                                        #
#                   1. Open the Script Editor.                                                                        #
#                   2. Select "PowerShell Libraries" from the File menu.                                              #
#                   3. Check the TMHelper module.                                                                     #
#                   4. Click on OK to close the "PowerShell Libraries" dialog.                                        #
#                   Alternatively you can load the module from the embedded console by invoking this:                 #
#                       Import-Module -Name System.Object[]                                                           #
#                   Please provide feedback on the PowerGUI Forums.                                                   #
#######################################################################################################################

add-type -path 'C:\Program Files\SDL\SDL Trados Studio\Studio2\Sdl.LanguagePlatform.TranslationMemoryApi.dll';
add-type -path 'C:\Program Files\SDL\SDL Trados Studio\Studio2\Sdl.LanguagePlatform.TranslationMemory.dll';


<#
	.DESCRIPTION
	Creates a new file based TM.
#>
function New-FileBasedTM
{
	param([String] $filePath,[String] $description, [String] $sourceLanguageName, [String] $targetLanguageName, 
		[Sdl.LanguagePlatform.TranslationMemory.FuzzyIndexes] $fuzzyIndexes, 
		[Sdl.LanguagePlatform.Core.Tokenization.BuiltinRecognizers] $recognizers)
	
	
	$sourceLanguage = Get-CultureInfo $sourceLanguageName;
	$targetLanguage = Get-CultureInfo $targetLanguageName;

	[Sdl.LanguagePlatform.TranslationMemoryApi.FileBasedTranslationMemory] $tm = 
	New-Object Sdl.LanguagePlatform.TranslationMemoryApi.FileBasedTranslationMemory ($filePath,
	$description, $sourceLanguage, $targetLanguage, $fuzzyIndexes, $recognizers);	
}

function Open-FileBasedTM
{
	param([String] $filePath)
	[Sdl.LanguagePlatform.TranslationMemoryApi.FileBasedTranslationMemory] $tm = 
	New-Object Sdl.LanguagePlatform.TranslationMemoryApi.FileBasedTranslationMemory ($filePath);
	
	return $tm;
}

function Get-TargetTMLanguage
{
	param([String] $filePath)
	
	[Sdl.LanguagePlatform.TranslationMemoryApi.FileBasedTranslationMemory] $tm = Open-FileBasedTM $filePath;
	[Sdl.LanguagePlatform.TranslationMemoryApi.FileBasedTranslationMemoryLanguageDirection] $direction = $tm.LanguageDirection;
	return $direction.TargetLanguage;	
}

function Get-Language
{
	param([String] $languageName)
	
	[Sdl.Core.Globalization.Language] $language = New-Object Sdl.Core.Globalization.Language ($languageName)
	return $language;
}

function Get-Languages
{
	param([String[]] $languageNames)
	[Sdl.Core.Globalization.Language[]]$languages = @();
	foreach($lang in $languageNames)
	{
		$newlang = Get-Language $lang;
		
		$languages = $languages + $newlang
	}

	return $languages
}

function Get-CultureInfo
{
	param([String] $languageName)
	$cultureInfo = Get-Language $languageName;
	return [System.Globalization.CultureInfo] $cultureInfo.CultureInfo;
}

function Get-DefaultFuzzyIndexes
{
	 return [Sdl.LanguagePlatform.TranslationMemory.FuzzyIndexes]::SourceCharacterBased -band 
	 	[Sdl.LanguagePlatform.TranslationMemory.FuzzyIndexes]::SourceWordBased -band
		[Sdl.LanguagePlatform.TranslationMemory.FuzzyIndexes]::TargetCharacterBased -band
		[Sdl.LanguagePlatform.TranslationMemory.FuzzyIndexes]::TargetWordBased;
}

function Get-DefaultRecognizers
{
	return [Sdl.LanguagePlatform.Core.Tokenization.BuiltinRecognizers]::RecognizeAcronyms -band
	[Sdl.LanguagePlatform.Core.Tokenization.BuiltinRecognizers]::RecognizeAll -band
	[Sdl.LanguagePlatform.Core.Tokenization.BuiltinRecognizers]::RecognizeDates -band
	[Sdl.LanguagePlatform.Core.Tokenization.BuiltinRecognizers]::RecognizeMeasurements -band
	[Sdl.LanguagePlatform.Core.Tokenization.BuiltinRecognizers]::RecognizeNumbers -band
	[Sdl.LanguagePlatform.Core.Tokenization.BuiltinRecognizers]::RecognizeTimes -band
	[Sdl.LanguagePlatform.Core.Tokenization.BuiltinRecognizers]::RecognizeVariables;
}

Export-ModuleMember New-FileBasedTM;
Export-ModuleMember Get-DefaultFuzzyIndexes;
Export-ModuleMember Get-DefaultRecognizers;
Export-ModuleMember Get-Language;
Export-ModuleMember Get-Languages;
Export-ModuleMember Open-FileBasedTM;
Export-ModuleMember Get-TargetTMLanguage;


