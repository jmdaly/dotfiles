# PowerShell Profile
# Source in $env:homepath\Documents\PowerShell\Microsoft.PowerShell_profile.ps1

if ($IsLinux) {
	$env:WINHOME="/c/users/$env:USERNAME/"
} else {
	$env:WINHOME="${HOME}"
}

$posh_dir = $(Join-Path ${HOME} dotfiles posh)
if (Test-Path $(Join-Path ${HOME} dotfiles dotfiles-secret))
{
	$priv_dir = $(Join-Path ${HOME} dotfiles dotfiles-secret)
}
elseif (Test-Path $(Join-Path ${HOME} dotfiles-secret))
{
	$priv_dir = $(Join-Path ${HOME} dotfiles-secret)
}
else
{
	$priv_dir = ""
}


if (Test-Path $priv_dir\proxy.ps1)
{
	. "$priv_dir\proxy.ps1"
}

#. "$posh_dir\env-modules.ps1"
. "$posh_dir/sync.ps1" # Temp until env modules work
. "$posh_dir\vs19.ps1"
. "$posh_dir\python.ps1"
. "$posh_dir\env.ps1"
. "$posh_dir\git-aliases.ps1"
. "$posh_dir\paths.ps1"
. "$posh_dir\utils.ps1"
. "$posh_dir\docker.ps1"

# vim: ts=4 sw=4 sts=0 noexpandtab ff=dos ft=ps1 :
