# Profile for Solacom.  Right now this is a very Solacom-specific profile, I'll
# create a new one or split this somehow if ever I need a more general profile

# TODO
# Split this into smaller files or something

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

# If it exists, load our python virtualenv
if (Test-path python) {
	Write-Host "`nLoading python virtual env." -ForegroundColor Yellow
	.virtualenvs\default\Scripts\activate.ps1
}

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
# https://github.com/dahlbyk/posh-sshell
Install-Module posh-sshell -AllowClobber
Install-Module ThreadJob

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

# Open a tunnel to khea
function khea-vnc { ssh -nNT khea & }

# Add some directories to our path.
$java_jdk="C:/Progra~1/Java/jdk1.8.0_211"
$custom_paths = @(
	("nmap.exe", "C:/Progra~2/Nmap"),
	("notepad++.exe", "C:/Progra~1/Notepad++"),
	("mysql.exe", "c:/Progra~1/MariaDB 10.3/bin"),
	("Code.exe", "C:/Progra~1\Microsoft VS Code"),
	("java.exe", "C:/java-1.8.0-openjdk-1.8.0.201-2.b09.redhat.windows.x86_64/bin"),
	("javax.mail.jar", "C:/jaf-1_1_1/jaf-1.1.1")
)
$custom_paths | ForEach-Object {
    if ((Test-Path $_[1]) -And ((Get-Command $_[0] -ErrorAction SilentlyContinue) -eq $null)) {
		$env:path = $_[1] + ";$env:path"
	}
}

# Function to try to make searching easier, and show full paths
function search {
    Param($Path, $Filter)
    Get-ChildItem -Path $Path -Filter $Filter -Recurse -File | % {
         Write-Host $_.FullName
    }
}

function iqadmin-debug {
	Push-Location "c:\EdgeIQ\IQAdmin"

	Start-Process                                `
		-FilePath java.exe                       `
		-ArgumentList "-Xmx512m ", `
			"-Xdebug", "-Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5431", `
			"-classpath iqadmin.jar;dom4j-1.6.1.jar;mariadb-java-client-2.4.0.jar;axis.jar;commons-discovery-0.2.jar;javax.wsdl.jar;jaxrpc.jar;org.apache.commons.logging.jar;saaj.jar;activation.jar;javax.mail.jar", `
			"com.versatelnetworks.admin.IQAdmin", `
			"-probe",                             `
			"-gateway -gatewaysr"

	Pop-Location
}

function iqadmin {
	Push-Location "c:\EdgeIQ\IQAdmin"

	Start-Process                                  `
		-FilePath javaw.exe                        `
		-ArgumentList "-Xmx512m",                  `
			"-classpath iqadmin.jar;dom4j-1.6.1.jar;mariadb-java-client-2.4.0.jar;axis.jar;commons-discovery-0.2.jar;javax.wsdl.jar;jaxrpc.jar;org.apache.commons.logging.jar;saaj.jar", `
			"com.versatelnetworks.admin.IQAdmin",  `
			"-probe", "-gateway", "-gatewaysr"

	Pop-Location
}

# References: https://mathieubuisson.github.io/powershell-linux-bash/

# vim: ts=4 sw=4 sts=0 noexpandtab ffs=dos ft=ps1 :
