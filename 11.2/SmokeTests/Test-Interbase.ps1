[Diagnostics.CodeAnalysis.SuppressMessageAttribute(
    "PSAvoidUsingPlainTextForPassword", "")] # suppress warning about plain text password parameter
Param(
    [string] $ISQLPath = "", 
    [string] $IBUsername = "sysdba", 
    [string] $IBPassword = "masterkey"
)

function main(){
    Set-Location $PSScriptRoot

    $isql = Get-ISQLPath $ISQLPath
    $user = $IBUsername
    $password = $IBPassword

    $ScriptName = (Get-Item $PSCommandPath ).Basename
    $dbname = "$ScriptName.ib"
    $reference = "$ScriptName.reference"
    $SQL = "$ScriptName.sql"
    $Output = "$ScriptName.output"

    if (Test-Path $dbname) { Remove-Item $dbname }
    if (Test-Path $Output) { Remove-Item $Output }

    try {
        & ($isql) -echo -merge_stderr `
            -input $SQL -output $Output `
            -user $user -password $password

        Write-Verbose "ISQL exitcode is $LASTEXITCODE "
    }
    finally {
        if (Test-Path $dbname) { Remove-Item $dbname }
    }

    if ( Compare-Object -ReferenceObject (Get-Content $reference) `
            -DifferenceObject (Get-Content $Output)) {
        Write-Warning "Interbase ran with problems. Check $Output"
        exit 1
    }
    else {
        Remove-Item $Output
        Write-Output "Interbase works ok"
        exit 0
    }
}
function Get-ISQLPath([string] $ISQLPathParam) {
    $FuncName = (Get-PSCallStack)[0].Command
    $isql = "bin\isql.exe"

    if ($ISQLPathParam -ne "") {
        return $ISQLPathParam
    } else {

        $FallbackPath = Join-Path "C:\Program Files\Embarcadero\InterBase\" $isql

        $IBInstalls = Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\" `
            | Where-Object { $_.Name -match ".*Embarcadero Interbase.*" }
        if ($IBInstalls.Length -lt 1) {
            Write-Warning (-join ("$FuncName : Could not find Interbase installation. ",
            "Falling back to default path, $FallbackPath"))
            $Result = $FallbackPath
        }else{
            $theInstall = $IBInstalls[0]
            if ($IBInstalls.Length -gt 1){
                Write-Warning (-join ("$FuncName : There seem to be several Interbase ",
                    "installations. Path will be taken from ",
                    """$($theInstall.GetValue('DisplayName'))"""))
            }
            $Result = Join-Path $theInstall.GetValue('InstallLocation') $isql
        }

        if (-not(Test-Path $Result)) {
            throw ( -join("$FuncName : There is no ""$Result"" file found. ",
                "Please install interbase client or specify ",
                "the path using -ISQLPath parameter"))
        }else{
            Write-Verbose "$FuncName : Determined path - ""$Result"""
            return $Result
        }
    }
}

main