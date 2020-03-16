Write-Host "Loading docker aliases" -ForegroundColor Yellow

# Install-Module posh-docker -Scope CurrentUser
Import-Module posh-docker

. $posh_dir\Set-ProfileForDocker.ps1

function Stop-Docker { docker stop $args; }
# function Prune-DockerContainers { docker containers prune }
# function Prune-DockerVolume { docker volumes prune }
# function Exectute-Docker { docker execute $args }
function Get-DockerPs { docker ps }

function DockerCompose-Up { docker-compose up -d }

#
New-Alias -Force -Name dkx Stop-Docker
# New-Alias dkCpr Prune-DockerContainers
# New-Alias dke Execute-Docker
New-Alias -Name dkls Get-DockerPs
New-Alias -Name dkcU DockerCompose-Up
