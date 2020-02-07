Write-Host "Loading docker aliases" -ForegroundColor Yellow

# Install-Module posh-docker -Scope CurrentUser
Import-Module posh-docker

. $posh_dir\Set-ProfileForDocker.ps1

function Stop-Docker { docker stop $_ }
# function Prune-DockerContainers { docker containers prune }
# function Prune-DockerVolume { docker volumes prune }
# function Exectute-Docker { docker execute $_ }
function Get-DockerPs { docker ps }
#
New-Alias dkx Stop-Docker
# New-Alias dkCpr Prune-DockerContainers
# New-Alias dke Execute-Docker
New-Alias dkls Get-DockerPs
