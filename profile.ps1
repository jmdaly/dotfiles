# VC Vars https://stackoverflow.com/a/2124759/1861346
pushd "C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\Common7\Tools"
cmd /c "VsDevCmd.bat&set" |
foreach {
  if ($_ -match "=") {
    $v = $_.split("="); set-item -force -path "ENV:\$($v[0])"  -value "$($v[1])"
  }
}
popd
Write-Host "`nVisual Studio 2017 Command Prompt variables set." -ForegroundColor Yellow

# https://github.com/joonro/Get-ChildItemColor
# verify this is the console and not the ISE
Import-Module Get-ChildItemColor

Set-Alias l Get-ChildItemColor -option AllScope
Set-Alias ls Get-ChildItemColor -option AllScope

Write-Host "`nLoaded custom ls" -ForegroundColor Yellow

# Helper function to set location to the User Profile directory
function cuserprofile { Set-Location ~ }
Set-Alias ~ cuserprofile -Option AllScope

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


# Oh-my-posh https://github.com/JanDeDobbeleer/oh-my-posh
Import-Module posh-git

# Start SshAgent if not already
# Need this if you are using github as your remote git repository
if (! (ps | ? { $_.Name -eq 'ssh-agent'})) {
    Start-SshAgent
}

Import-Module oh-my-posh
# https://github.com/JanDeDobbeleer/oh-my-posh/tree/master/Themes
Set-Theme robbyrussell

# Aliases for git
Install-Module git-aliases -Scope CurrentUser -AllowClobber

# Override
function gst {
	git status -uno -sb $args
}

# Add some directories to our path.
$custom_paths = @("C:\Program Files (x86)\Nmap", "C:\Program Files\Notepad++")
$custom_paths | ForEach-Object {
    if (Test-Path $_) { $env:path="$_;$env:path" }
}

# Function to try to make searching easier, and show full paths
function search {
    Param($Path, $Filter)
    Get-ChildItem -Path $Path -Filter $Filter -Recurse -File | % {
         Write-Host $_.FullName
    }
}

# References: https://mathieubuisson.github.io/powershell-linux-bash/

# vim: ts=4 sw=4 sts=0 noexpandtab ffs=dos ft=ps1 :
