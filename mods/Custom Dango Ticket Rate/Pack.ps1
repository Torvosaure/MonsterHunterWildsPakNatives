try {
    Set-Location -Path $PSScriptRoot

    $OutDir = "../../dist"

    if (-not (Test-Path -Path $OutDir)) {
        New-Item -Path $OutDir -ItemType Directory
    }

    Compress-Archive -Path "reframework" -DestinationPath "$OutDir/$((Get-Item -Path $PSScriptRoot).Name).zip" -Force
}
finally {
    Set-Location -Path -
}
