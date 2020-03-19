Install-Module posh-docker
Install-Module posh-git
Install-Module oh-my-posh
Install-Module Get-ChildItemColor -AllowClobber
Install-Module -Name posh-sshell
Install-Module -Name ThreadJob
Install-Module posh-docker -Scope AllUsers
Install-Module git-aliases -Scope AllUsers -AllowClobber

# https://github.com/DTW-DanWard/PowerShell-Beautifier
Install-Module -Name PowerShell-Beautifier

# Static Analyzer for PS scripts
Install-Module -Name PSScriptAnalyzer

# Unit tests
Install-Module -Name Pester

# https://awesomeopensource.com/project/mikemaccana/powershell-profile
Install-Module Pscx -Scope CurrentUser
Install-Module -Name Recycle -Scope CurrentUser
