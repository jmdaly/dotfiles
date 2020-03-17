Write-Host "Loading docker aliases" -ForegroundColor Yellow

# Install-Module posh-docker -Scope CurrentUser
Import-Module posh-docker

. $posh_dir\Set-ProfileForDocker.ps1

# TODO rename these to start with either Docker or Docker-Compose

function Stop-Docker { docker stop $args }
function Prune-DockerContainers { docker containers prune }
function Prune-DockerVolume { docker volumes prune }
function Exectute-Docker { docker execute $args }
function Get-DockerPs { docker ps }

function DockerCompose-Up { docker-compose up -d $args }
function DockerCompose-Build { docker-compose build $args }

New-Alias -Force -Name dkx Stop-Docker
New-Alias -Force -Name dkCpr Prune-DockerContainers
New-Alias -Force -Name dke Execute-Docker
New-Alias -Force -Name dkls Get-DockerPs
New-Alias -Force -Name dkcU DockerCompose-Up
New-Alias -Force -Name dkcb DockerCompose-Build
