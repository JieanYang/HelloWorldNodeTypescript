<powershell>
Write-Output "OS: Windows"
Write-Output "This is a message before the error."
Write-Output "Error: a custimize error message from scripts" >&2
exit 1
Write-Output "This is a message after the error. This line will not be executed." # will never show up
</powershell>