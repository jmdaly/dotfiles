if ($IsWindows)
{
# VC Vars https://stackoverflow.com/a/2124759/1861346
#
# Review how MS Terminal does it with Set-MsBuildDevEnvironment at
# https://github.com/microsoft/terminal tools/OpenConsole.psm1
	$vspath = $(wslpath -a "C:\\Program Files (x86)\\Microsoft Visual Studio\\2017\\Professional\\Common7\\Tools")
	pushd $vspath
	cmd /c "VsDevCmd.bat&set" |
	foreach {
	  if ($_ -match "=") {
		$v = $_.split("="); set-item -force -path "ENV:\$($v[0])"  -value "$($v[1])"
	  }
	}
	popd
	Write-Host "`nVisual Studio 2017 Command Prompt variables set." -ForegroundColor Yellow
}

if ($IsLinux)
{
	$vcpkg_install_dir="${HOME}/workspace2/vcpkg"
} else {
	$vcpkg_install_dir="${HOME}\workspace\vcpkg"
}
if (Test-Path $vcpkg_install_dir)
{
	Write-Host "Loading vcpkg Powershell Integration." -ForegroundColor Yellow
	Import-Module "${vcpkg_install_dir}\scripts\posh-vcpkg"
	$env:path = "${vcpkg_install_dir};" + $env:path

}

# vim: ts=4 sw=4 sts=0 noexpandtab ffs=unix ft=ps1 :
