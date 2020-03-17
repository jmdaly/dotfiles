Rename-Item Function:\Prompt PoshGitPrompt -Force
function Prompt() {if(Test-Path Function:\PrePoshGitPrompt){++$global:poshScope; New-Item function:\script:Write-host -value "param([object] `$object, `$backgroundColor, `$foregroundColor, [switch] `$nonewline) " -Force | Out-Null;$private:p = PrePoshGitPrompt; if(--$global:poshScope -eq 0) {Remove-Item function:\Write-Host -Force}}PoshGitPrompt}

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# Docker Module
# This is slow!
Install-Module posh-docker -Scope CurrentUser

# Docker Aliases
# @ https://www.ctl.io/developers/blog/post/15-quick-docker-tips/
# @ https://gist.github.com/sixeyed/adce79b18c5f572feaf34ae9e90513c2

# dl
function Return-ContainerID {(docker ps -l -q)}

# docker rm $(docker ps -a -q)
function Remove-StoppedContainers {
    foreach ($id in & docker ps -a -q) {
        & docker rm $id
    }
}

# docker rmi $(docker images -f "dangling=true" -q)
function Remove-DanglingImages {
    foreach ($id in & docker images -q -f 'dangling=true') {
        & docker rmi $id
    }
}

# docker volume rm $(docker volume ls -qf dangling=true)
function Remove-DanglingVolumes {
    foreach ($id in & docker volume ls -q -f 'dangling=true') {
        & docker volume rm $id
    }
}

# docker inspect --format '{{ .NetworkSettings.Networks.nat.IPAddress }}' <id>
function Get-ContainerIPAddress {
    param (
        [string] $id
    )
    & docker inspect --format '{{ .NetworkSettings.Networks.nat.IPAddress }}' $id
}

New-Alias dl Return-ContainerID

New-Alias drm Remove-StoppedContainers

New-Alias drmi  Remove-DanglingImages

New-Alias drmv  Remove-DanglingVolumes

New-Alias dip Get-ContainerIPAddress

# vim: set ts=4 sw=4 tw=0 et :
