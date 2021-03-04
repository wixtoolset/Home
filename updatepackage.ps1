param([string]$TargetFolder, [string]$PackageName, [string]$NewVersion)

function updateGlobalJson {
    param($targetFile, [string]$packageName, [string]$newVersion)

    #Write-Host 'global.json' $targetFile
    $changed = $false
    $fileContents = [System.IO.File]::ReadAllText($targetFile)
    $matches = [System.Text.RegularExpressions.Regex]::Matches($fileContents, "['""]$packageName['""]: *['""]([^'""]*)['""]")
    $matches | ForEach-Object {
        #$previousVersion = $_.Groups[1]
        #Write-Host $previousVersion
        $fileContents = $fileContents.Replace($_.Value, """$packageName"": ""$newVersion""")
        $changed = $true
    }
    if ($changed) {
        [System.IO.File]::WriteAllText($targetFile, $fileContents)
    }
}

function updatePackagesConfig {
    param($targetFile, [string]$packageName, [string]$newVersion)

    #Write-Host 'packages' $targetFile
    $xml = New-Object XML
    $xml.Load($targetFile)
    $query = "/packages/package[@id='" + $packageName + "']";
    $packageNode = $xml.SelectSingleNode($query);
    if ($packageNode) {
        $previousVersion = $packageNode.Attributes['version'].Value
        #Write-Host $previousVersion
        if ($previousVersion -ne $newVersion) {
            $packageNode.Attributes['version'].Value = $newVersion
            $xml.Save($targetFile)
        }
    }
}

function updateProject {
    param($targetFile, [string]$packageName, [string]$newVersion)

    #Write-Host 'project' $targetFile
    $changed = $false
    $fileContents = [System.IO.File]::ReadAllText($targetFile) # project files should be small right?
    $oldStyleMatches = [System.Text.RegularExpressions.Regex]::Matches($fileContents,  '[\\">]packages\\' + $packageName + '\.([0-9][^\\]*)\\')
    $oldStyleMatches | ForEach-Object {
        $previousVersion = $_.Groups[1]
        #Write-Host $previousVersion
        $fileContents = $fileContents.Replace($packageName + '.' + $previousVersion, $packageName + '.' + $newVersion)
        $changed = $true
    }
    # hmmm, don't want to use XML parsing for the whole document because it might make annoying formatting changes throughout the file
    # let's assume PackageReference elements don't span multiple lines
    $packageReferenceMatches = [System.Text.RegularExpressions.Regex]::Matches($fileContents,  '<PackageReference.*' + $packageName + '.*>', 'IgnoreCase')
    $packageReferenceMatches | ForEach-Object {
        $xml = New-Object XML
        $xml.LoadXml($_.Value)
        $query = "//PackageReference[translate(@Include, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')='" + $packageName.ToLower() + "']";
        $packageReferenceNode = $xml.SelectSingleNode($query);
        if ($packageReferenceNode) {
            $previousVersion = $packageReferenceNode.Attributes['Version'].Value
            #Write-Host $previousVersion
            if ($previousVersion -ne $newVersion) {
                $packageReferenceNode.Attributes['Version'].Value = $newVersion
                $fileContents = $fileContents.Replace($_.Value, $packageReferenceNode.OuterXml)
                $changed = $true
            }
        }
    }
    if ($changed) {
        [System.IO.File]::WriteAllText($targetFile, $fileContents)
    }
}

function updateNugetPackageVersion {
    param([string]$targetFolder, [string]$packageName, [string]$newVersion)

    Get-ChildItem -Path $targetFolder -Include global.json -Recurse | ForEach-Object {
        updateGlobalJson -targetFile $_ -packageName $packageName -newVersion $newVersion
    }

    Get-ChildItem -Path $targetFolder -Include packages.config -Recurse | ForEach-Object {
        updatePackagesConfig -targetFile $_ -packageName $packageName -newVersion $newVersion
    }

    Get-ChildItem -Path $targetFolder -Include *.*proj -Recurse | ForEach-Object {
        updateProject -targetFile $_ -packageName $packageName -newVersion $newVersion
    }
}

updateNugetPackageVersion -targetFolder $TargetFolder -packageName $PackageName -newVersion $NewVersion