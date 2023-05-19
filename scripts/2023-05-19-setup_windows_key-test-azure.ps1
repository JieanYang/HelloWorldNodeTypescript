Write-Output "OS: Windows"

Write-Output "================ setup_windows_key.ps1 - start ================"
# $PSK_Key = -join ((48..57) + (65..90) + (97..122) | Get-Random -Count 32 | % {[char]$_})
$PSK_Key="PSK_KEY_GENERATED_BY_BACKEND" # This line will be replaced by backend
# $metaDir="$env:USERPROFILE\AppData\Roaming\.helloWorldGoAgent" # C:\Users\Administrator
$metaDir="$env:APPDATA\.helloWorldGoAgent" # C:\Users\Administrator\AppData\Roaming
Write-Output "metaDir:"
Write-Output $metaDir
if (-not (Test-Path -Path $metaDir)) {
    New-Item -ItemType Directory -Path $metaDir
}

$jsonObj = @{ "PSK_Key" = "$PSK_Key" }
$json = ConvertTo-Json $jsonObj
Set-Content -Path "${metaDir}\original_metadata.json" -Value $json
Set-Content -Path "C:\metadata.json" -Value $json
Write-Output "================ setup_windows_key.ps1 - end ================"
