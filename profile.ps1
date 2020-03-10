# PowerShell Profile

if ($IsLinux) {
	$env:WINHOME="/c/users/matthew.russell/"
} else {
	$env:WINHOME="${HOME}"
}

$posh_dir = $(Join-Path ${HOME} dotfiles posh)

. "$posh_dir\python.ps1"
. "$posh_dir\env.ps1"
. "$posh_dir\git-aliases.ps1"
. "$posh_dir\paths.ps1"
. "$posh_dir\utils.ps1"
. "$posh_dir\docker.ps1"

# vim: ts=4 sw=4 sts=0 noexpandtab ff=dos ft=ps1 :
