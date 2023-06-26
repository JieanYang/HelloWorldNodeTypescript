<powershell> # Tag powershell for AWS UserData
Write-Output "OS: Windows"

Write-Output "================ 2023-05-30-ansysCSPAgentManagerService_setup_windows.ps1 - start ================"
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

# === App path - start ===
$OS_SERVICE_MANAGER_APP_DIR_NAME="ansysCSPAgentManagerService"
$AGENT_APP_DIR_NAME="ansysCSPAgent"

$OS_SERVICE_MANAGER_APP_DIR = "$env:GOPATH\$OS_SERVICE_MANAGER_APP_DIR_NAME"
$AGENT_APP_DIR = "$OS_SERVICE_MANAGER_APP_DIR\$AGENT_APP_DIR_NAME"
Write-Output $OS_SERVICE_MANAGER_APP_DIR
Write-Output $AGENT_APP_DIR

$OS_SERVICE_MANAGER_APP_NAME="ansysCSPAgentManagerServiceApp.exe"
$AGENT_APP_NAME="ansysCSPAgentApp.exe"

$OS_SERVICE_MANAGER_APP = "${OS_SERVICE_MANAGER_APP_DIR}\$OS_SERVICE_MANAGER_APP_NAME"
$AGENT_APP = "${AGENT_APP_DIR}\..\$AGENT_APP_NAME"
Write-Output $OS_SERVICE_MANAGER_APP
Write-Output $AGENT_APP
# === App path - end ===

# Pull github
if (Test-Path $OS_SERVICE_MANAGER_APP_DIR) {
    Write-Output "Folder exists and pull from github in ${OS_SERVICE_MANAGER_APP_DIR}"
    Set-Location $OS_SERVICE_MANAGER_APP_DIR
    git add .
    git reset --hard HEAD
    git pull
} else {
    Write-Output "Clone github repository-start"
    git clone --branch dev-ansys-prod-dev https://github.com/JieanYang/HelloWorldGoOsService.git $OS_SERVICE_MANAGER_APP_DIR
    Set-Location $OS_SERVICE_MANAGER_APP_DIR
    git submodule update --init --recursive
    Write-Output "Clone github repository-end"
}

# Build OS service manager app
Set-Location $OS_SERVICE_MANAGER_APP_DIR
Write-Output "Build OS service manager app"
if (Test-Path $OS_SERVICE_MANAGER_APP) {
    Remove-Item $OS_SERVICE_MANAGER_APP
}
go build -o $OS_SERVICE_MANAGER_APP "${OS_SERVICE_MANAGER_APP_DIR}\main.go"

# Build ansysCSPAgentApp
Write-Output "Build ansysCSPAgentApp"
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

Write-Output "================ 2023-05-30-ansysCSPAgentManagerService_setup_windows.ps1 - start ================"
</powershell>