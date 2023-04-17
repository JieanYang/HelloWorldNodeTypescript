<powershell>
Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy RemoteSigned -Force
Get-ExecutionPolicy -List

$script = New-Object Net.WebClient
$script | Get-Member
$script.DownloadString("https://chocolatey.org/install.ps1")
iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex
choco upgrade chocolatey

choco install -y golang git.install
# $env:Path += 'C:\Program Files\Git\bin\git.exe;'
# $env:Path += 'C:\Program Files\Go\bin\go.exe;'

New-Alias -Name git -Value 'C:\Program Files\Git\bin\git.exe'
New-Alias -Name go -Value 'C:\Program Files\Go\bin\go.exe'

git clone --branch dev-helloWorldGoAgent https://github.com/JieanYang/supervisord-research.git C:\\Users\\Administrator\\supervisord-research
cd C:\\Users\\Administrator\\supervisord-research
git submodule update --init --recursive

go build # Build supervisord
cd C:\\Users\\Administrator\\supervisord-research\\helloWorldGoAgent
go build -o ./src/helloWorldGoAgent.exe ./src/main.go
cd C:\\Users\\Administrator\\supervisord-research


New-NetFirewallRule -DisplayName 'Go-application' -Profile @('Domain', 'Public','Private') -Direction Inbound -Action Allow -Protocol TCP -LocalPort @('9001')
New-Item 'C:\\supervisord' -Type Directory

# Start service
# .\supervisord.exe -c .\supervisord-windows.conf

# Register service as daemon
.\supervisord.exe service install -c C:\Users\Administrator\supervisord-research\supervisord-windows.conf
.\supervisord.exe service start
</powershell>