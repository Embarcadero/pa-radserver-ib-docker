Set-Location $PSScriptRoot

$ScriptName = (Get-Item $PSCommandPath ).Basename

$Result = $true
foreach ($TestScript in (Get-ChildItem -Path *.ps1)) {
    if($TestScript.BaseName -ne $ScriptName){
        $shortname = $TestScript.BaseName
        Write-Verbose "Running $shortname"
        & $TestScript
        $Result = $Result -and $?
        if(-not $?){
            Write-Warning "$shortname failed"
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