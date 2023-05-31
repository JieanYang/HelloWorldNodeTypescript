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

# === Download binary files - start ===
if (!(Test-Path -Path $OS_SERVICE_MANAGER_APP_DIR)) {
    New-Item -ItemType Directory -Path $OS_SERVICE_MANAGER_APP_DIR | Out-Null
    Write-Host "Folder created successfully."
}
else {
    Write-Host "Folder already exists."
}

if (!(Test-Path -Path "$AGENT_APP_DIR/src")) {
    New-Item -ItemType Directory -Path "$AGENT_APP_DIR/src" | Out-Null
    Write-Host "Folder created successfully."
}
else {
    Write-Host "Folder already exists."
}

$OS_SERVICE_MANAGER_APP_BINARY_URL = "https://ansys-gateway-development.s3.eu-west-3.amazonaws.com/windows/ansysCSPAgentManagerServiceApp.exe"
$OS_SERVICE_MANAGER_APP_INSTALL_SERVICE_URL = "https://ansys-gateway-development.s3.eu-west-3.amazonaws.com/windows/install_windows.bat"
$OS_SERVICE_MANAGER_APP_UNINSTALL_SERVICE_URL = "https://ansys-gateway-development.s3.eu-west-3.amazonaws.com/windows/uninstall_windows.bat"
$AGENT_APP_BINARY_URL = "https://ansys-gateway-development.s3.eu-west-3.amazonaws.com/windows/ansysCSPAgentApp.exe"

Invoke-WebRequest -Uri $OS_SERVICE_MANAGER_APP_BINARY_URL -OutFile $OS_SERVICE_MANAGER_APP
Invoke-WebRequest -Uri $OS_SERVICE_MANAGER_APP_INSTALL_SERVICE_URL -OutFile "$OS_SERVICE_MANAGER_APP_DIR/install_windows.bat"
Invoke-WebRequest -Uri $OS_SERVICE_MANAGER_APP_UNINSTALL_SERVICE_URL -OutFile "$OS_SERVICE_MANAGER_APP_DIR/uninstall_windows.bat"
Invoke-WebRequest -Uri $AGENT_APP_BINARY_URL -OutFile $AGENT_APP
# === Download binary files - end ===

# Add +x permission for two binary files
Set-Location $OS_SERVICE_MANAGER_APP_DIR
icacls $OS_SERVICE_MANAGER_APP /grant Everyone:F
icacls $AGENT_APP /grant Everyone:F

New-NetFirewallRule -DisplayName 'Go-application' -Profile @('Domain', 'Public','Private') -Direction Inbound -Action Allow -Protocol TCP -LocalPort @('9001')

Set-Location $OS_SERVICE_MANAGER_APP_DIR
./install_windows.bat

Write-Output "================ 2023-05-30-ansysCSPAgentManagerService_setup_windows.ps1 - start ================"
</powershell>