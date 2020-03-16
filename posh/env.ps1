# References: https://mathieubuisson.github.io/powershell-linux-bash/

# Helper function to show Unicode character
function U
{
	param
	(
		[int] $Code
	)

	if ((0 -le $Code) -and ($Code -le 0xFFFF))
	{
		return [char] $Code
	}

	if ((0x10000 -le $Code) -and ($Code -le 0x10FFFF))
	{
		return [char]::ConvertFromUtf32($Code)
	}

	throw "Invalid character code $Code"
}

if ($IsWindows -eq $null -And $env:WINHOME -eq $null)
{
	$env:WINHOME = $env:HOMEPATH
}

# Oh-my-posh https://github.com/JanDeDobbeleer/oh-my-posh
Write-Host "Loading posh-git" -ForegroundColor Yellow
Import-Module posh-git

if ($IsWindows)
{
	# Start SshAgent if not already
	# Need this if you are using github as your remote git repository
	if (! (ps | ? { $_.Name -eq 'ssh-agent'})) {
		Start-SshAgent
	}

	# I'd like to use gpg-agent, and I sort of am.. But I think something isn't setup fully yet, so for now point directly to plink
	$env:GIT_SSH="C:\Program Files\PuTTY\plink.exe"
}

Write-Host "Loading oh-my-posh" -ForegroundColor Yellow
Import-Module oh-my-posh
# https://github.com/JanDeDobbeleer/oh-my-posh/tree/master/Themes
Set-Theme robbyrussell

# vim: ts=4 sw=4 sts=0 noexpandtab ff=dos ft=ps1 :
