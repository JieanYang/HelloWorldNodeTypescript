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



Write-Output "OS: Windows"

Write-Output "HelloWorldGoOsService_setup_windows.ps1"
Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy RemoteSigned -Force
Get-ExecutionPolicy -List

$script = New-Object Net.WebClient
$script | Get-Member
$script.DownloadString("https://chocolatey.org/install.ps1")
iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex
choco upgrade chocolatey

choco install -y golang git.install

New-Alias -Name git -Value 'C:\Program Files\Git\bin\git.exe'
New-Alias -Name go -Value 'C:\Program Files\Go\bin\go.exe'

# Set path
Write-Output $env:PATH
$env:GOPATH = "C:\go"
$env:PATH = $env:PATH + ";" + $env:GOPATH + "\bin"
Write-Output $env:PATH

$OS_SERVICE_MANAGER_APP_DIR = "$env:GOPATH\agentOsService"
$AGENT_APP_DIR = "$OS_SERVICE_MANAGER_APP_DIR\helloWorldGoAgent"
Write-Output $OS_SERVICE_MANAGER_APP_DIR
Write-Output $AGENT_APP_DIR

# Pull github
if (Test-Path $OS_SERVICE_MANAGER_APP_DIR) {
    Write-Output "Folder exists and pull from github in ${OS_SERVICE_MANAGER_APP_DIR}"
    Set-Location $OS_SERVICE_MANAGER_APP_DIR
    git add .
    git reset --hard HEAD
    git pull
} else {
    Write-Output "Clone github repository-start"
    git clone --branch master https://github.com/JieanYang/HelloWorldGoOsService.git $OS_SERVICE_MANAGER_APP_DIR
    Set-Location $OS_SERVICE_MANAGER_APP_DIR
    git submodule update --init --recursive
    Write-Output "Clone github repository-end"
}

# Build OS service manager app
Set-Location $OS_SERVICE_MANAGER_APP_DIR
Write-Output "Build OS service manager app - HelloWorldGoOsService"
$OS_SERVICE_MANAGER_APP = "${OS_SERVICE_MANAGER_APP_DIR}\HelloWorldGoOsServiceApp.exe"
if (Test-Path $OS_SERVICE_MANAGER_APP) {
    Remove-Item $OS_SERVICE_MANAGER_APP
}
go build -o $OS_SERVICE_MANAGER_APP "${OS_SERVICE_MANAGER_APP_DIR}\main.go"

# Build helloWorldGoAgent
Write-Output "Build helloWorldGoAgent"
$AGENT_APP = "${AGENT_APP_DIR}\..\helloWorldGoAgentApp.exe"
if (Test-Path $AGENT_APP) {
    Remove-Item $AGENT_APP
}
Set-Location $AGENT_APP_DIR
go build -o $AGENT_APP "${AGENT_APP_DIR}\src\main.go"

# Add +x permission for two binary files
Set-Location $OS_SERVICE_MANAGER_APP_DIR
icacls $OS_SERVICE_MANAGER_APP /grant Everyone:F
icacls $AGENT_APP /grant Everyone:F

New-NetFirewallRule -DisplayName 'Go-application' -Profile @('Domain', 'Public','Private') -Direction Inbound -Action Allow -Protocol TCP -LocalPort @('9001')

Set-Location $OS_SERVICE_MANAGER_APP_DIR
./install_windows.bat