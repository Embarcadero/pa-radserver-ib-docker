Set-Location $PSScriptRoot

$ScriptName = (Get-Item $PSCommandPath ).Basename

$Result = $true
foreach ($TestScript in (Get-ChildItem -Path *.ps1)) {
    if($TestScript.BaseName -ne $ScriptName){
        $shortname = $TestScript.BaseName
        Write-Verbose "Running $shortname"
        try {
            & $TestScript
            if(-not $?){
                $Result = $false
                Write-Warning "$shortname failed gracefully. `$LASTEXITCODE is $LASTEXITCODE"
            }
            }
        catch {
            $Result = $false
            Write-Warning "$shortname failed with exception: ""$_"""
        }
    }
}

if ($Result) {
    Write-Output "All tests passed ok"
    exit 0
}else {
    Write-Output "One or more tests failed."
    exit 1
}