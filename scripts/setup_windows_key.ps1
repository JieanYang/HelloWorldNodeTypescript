<powershell>
Write-Output "================ setup_windows_key.ps1 - start ================"
$key = -join ((48..57) + (65..90) + (97..122) | Get-Random -Count 32 | % {[char]$_})
$keyDir = "$env:USERPROFILE\.HelloWorldGoAgent"
if (-not (Test-Path -Path $keyDir)) {
    New-Item -ItemType Directory -Path $keyDir
}
Set-Content -Path "${keyDir}\PSK_key.txt" -Value $key
Write-Output "================ setup_windows_key.ps1 - end ================"
</powershell>