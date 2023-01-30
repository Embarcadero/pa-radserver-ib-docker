Set-Location $PSScriptRoot

$isql = "C:\Program Files\Embarcadero\InterBase\bin\isql.exe"
$user = "sysdba"
$password = "masterkey"

$ScriptName = (Get-Item $PSCommandPath ).Basename
$dbname = "$ScriptName.ib"
$reference = "$ScriptName.reference"
$SQL = "$ScriptName.sql"
$Output = "$ScriptName.output"

if (Test-Path $dbname) {Remove-Item $dbname}
if (Test-Path $Output) {Remove-Item $Output}

try {
    & ($isql) -echo -merge_stderr `
        -input $SQL -output $Output `
        -user $user -password $password

    Write-Verbose "ISQL exitcode is $LASTEXITCODE "
}
finally {
    if (Test-Path $dbname) {
        Remove-Item $dbname
    }
}

if ( Compare-Object -ReferenceObject (Get-Content $reference) `
        -DifferenceObject (Get-Content $Output)) {
    Write-Verbose "Interbase ran with problems. Check $Output"
    exit 1
}
else {
    Remove-Item $Output
    Write-Verbose "Interbase works ok"
    exit 0
}