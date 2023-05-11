<powershell> # Tag powershell for AWS UserData
Write-Output "OS: Windows"

Write-Output "================ setup_windows_key.ps1 - start ================"
# $key = -join ((48..57) + (65..90) + (97..122) | Get-Random -Count 32 | % {[char]$_})
$key="${PSK_KEY_GENERATED_BY_BACKEND}" # This line will be replaced by backend
$keyDir="$env:USERPROFILE\AppData\Roaming\.helloWorldGoAgent" # C:\Users\Administrator
Write-Output "key_dir:"
Write-Output $key_dir
if (-not (Test-Path -Path $keyDir)) {
    New-Item -ItemType Directory -Path $keyDir
}

$jsonObj = @{ "key" = "$key" }
$json = ConvertTo-Json $jsonObj
Set-Content -Path "${keyDir}\original_metadata.json" -Value $json
Write-Output "================ setup_windows_key.ps1 - end ================"
</powershell>