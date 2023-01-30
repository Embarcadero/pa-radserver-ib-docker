Set-Location $PSScriptRoot

try{
    $Response = Invoke-WebRequest -Uri "localhost/radserver/version"
}catch [System.Net.WebException]{
    Write-Verbose "RAD server responded with error code $($_.Exception.Response.StatusCode.value__)"
    if ($_.Exception.Response.StatusCode.value__ -eq 403) {
        Write-Verbose "RAD Server seem to be installed and can work, but not licensed"
        exit 0
    } else {
        Write-Verbose "RAD Server does not seem to be working"
        exit 1
    }
}

Write-Verbose "RAD Server is installed and works"
Write-Verbose "Response is: `n$($Response.Content)"
exit 0