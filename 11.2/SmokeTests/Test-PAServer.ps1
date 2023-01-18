Set-Location $PSScriptRoot

# find out RAD Studio directory
$BDSVersion = "22.0"
$BDSDirectory = (Get-ItemProperty `
    -Path "registry::HKEY_CURRENT_USER\SOFTWARE\Embarcadero\BDS\$BDSVersion" `
    -Name RootDir).RootDir

# Check if RAD Studio path is correct and there is PAClient in it.
$PAClient="$BDSDirectory\bin\paclient.exe"
if(-not $(Test-Path $PAClient)){
    throw -join(
        "Cannot continue - there is no PAClient executable at the path `"$PAClient`".`n",
        "Please check if RAD Studio is installed."
    )
}

# Assign specific vars based on $PAClient
$PAClientFileInfo = Get-Item $PAClient
$PAClientFileName= -join ($PAClientFileInfo.BaseName, $PAClientFileInfo.Extension)

# Try file upload
& $PAClient --host=localhost --put=$PAClient,. > $null
if (-not $?) {
    throw "PAServer does not work - cannot upload file"
}

# Try file download
& $PAClient --host=localhost --get=./$PAClientFilename,. > $null
if (-not $(Test-Path ./$PAClientFilename)) {
    throw "PAServer does not seem to work - cannot download file"
}

try {
    # Check if file intact
    if (Compare-Object -ReferenceObject $(Get-Content $PAClient) -DifferenceObject $(Get-Content $PAClientFileName)) {
        throw "PAServer does not seem to work - file downloaded differs from file uploaded"
    }
}
finally {
    Remove-Item $PAClientFileName
}

Write-Output "PAServer smoke test passed ok"
exit 0 # just for readability, as exitcode is 0 implicitly