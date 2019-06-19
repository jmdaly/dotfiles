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

# https://github.com/dahlbyk/posh-sshell
Import-Module -Name posh-sshell
Import-Module -Name Posh-SSH
Import-Module -Name ThreadJob

# Open a tunnel to khea, replies on module Thread-Job
function khea-vnc { ssh -nNT khea & }

# vim: ts=4 sw=4 sts=0 noexpandtab ffs=dos ft=ps1 :
