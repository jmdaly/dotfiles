# Misc functions
Write-Host "Loading misc functions" -ForegroundColor Yellow

# Helper function to set location to the User Profile directory
function cuserprofile { Set-Location ~ }
Set-Alias ~ cuserprofile -Option AllScope

# https://github.com/joonro/Get-ChildItemColor
# verify this is the console and not the ISE
Import-Module Get-ChildItemColor
Set-Alias ls Get-ChildItemColor -option AllScope

# Linux `which`
New-Alias which Get-Command

# Other aliases
New-Alias wget Invoke-WebRequest

# https://github.com/dahlbyk/posh-sshell

# Get info about whatever process is using a specified port
function Get-PortUser($port) { Get-Process -Id (Get-NetTCPConnection -LocalPort $port).OwningProcess; }

# vim: ts=4 sw=4 sts=0 noexpandtab ff=dos ft=ps1 :
