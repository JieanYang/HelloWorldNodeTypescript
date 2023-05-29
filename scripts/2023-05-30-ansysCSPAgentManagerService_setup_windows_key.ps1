<powershell> # Tag powershell for AWS UserData
Write-Output "OS: Windows"

$AGENT_APP_DIR_NAME="ansysCSPAgent"

Write-Output "================ 2023-05-30-ansysCSPAgentManagerService_setup_windows_key.ps1 - start ================"
# $PSK_Key = -join ((48..57) + (65..90) + (97..122) | Get-Random -Count 32 | % {[char]$_})
$PSK_Key="${PSK_KEY_GENERATED_BY_BACKEND}" # This line will be replaced by backend
# $metaDir="$env:USERPROFILE\AppData\Roaming\.ansysCSPAgent" # C:\Users\Administrator
$metaDir="$env:APPDATA\.$AGENT_APP_DIR_NAME" # C:\Users\Administrator\AppData\Roaming
Write-Output "metaDir:"
Write-Output $metaDir
if (-not (Test-Path -Path $metaDir)) {
    New-Item -ItemType Directory -Path $metaDir
}

$jsonObj = @{ "psk_key" = "$PSK_Key" }
$json = ConvertTo-Json $jsonObj
Set-Content -Path "${metaDir}\original_metadata.json" -Value $json
Write-Output "================ 2023-05-30-ansysCSPAgentManagerService_setup_windows_key.ps1 - end ================"
</powershell>