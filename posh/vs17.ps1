if ($IsWindows)
{
	# VC Vars https://stackoverflow.com/a/2124759/1861346
	#
	# Review how MS Terminal does it with Set-MsBuildDevEnvironment at
	# https://github.com/microsoft/terminal tools/OpenConsole.psm1
	$vspath = $(wslpath -a "C:\\Program Files (x86)\\Microsoft Visual Studio\\2017\\Professional\\Common7\\Tools")
	pushd $vspath
	cmd.exe /c "VsDevCmd.bat&set" |
	foreach {
	  if ($_ -match "=") {
		$v = $_.split("="); set-item -force -path "ENV:\$($v[0])"  -value "$($v[1])"
	  }
	}
	popd
	Write-Host "`nVisual Studio 2017 Command Prompt variables set." -ForegroundColor Yellow
}
else
{
	# Once I started using the proper (Windows) msbuild executable (forced it
	# with an alias below - otherwise it'll use /use/bin/msbuild) stuff just
	# worked, so it's possible that I don't need to set $env:VCTargetPath If I
	# do though, I think it's at (note the two examples have slightly different
	# paths)
	# /c/Program Files (x86)/Microsoft Visual Studio/2017/BuildTools/Common7/IDE/VC/VCTargets/Microsoft.Cpp.Default.props
	# e.g.  $env:VCTargetPath="$(wslpath "C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\Common7\IDE\VC\VCTargets\")"

	function msbuild {
		Write-Host "Overwriting msbuild"
		&"$(wslpath "C:/Program Files (x86)/Microsoft Visual Studio/2017/Professional/MSBuild/15.0/Bin/MsBuild.exe")" $args
	}
}

# Some code to setup msbuild from Get-VSSetupInstance, but I don't
# think I need it
# https://blog.lextudio.com/locate-msbuild-via-powershell-on-different-operating-systems-140757bb8e18


# Because I only use PS right now to help with Windows stuff (I
# don't build linux apps with it, not yet at least), always target
# Windows' vcpkg
$vcpkg_install_dir=Join-Path ${env:WINHOME} vcpkg
if (Test-Path $vcpkg_install_dir)
{
	Write-Host "Loading vcpkg Powershell Integration." -ForegroundColor Yellow

	Import-Module $(Join-Path $vcpkg_install_dir scripts posh-vcpkg)
	$env:PATH = "${vcpkg_install_dir}$([IO.Path]::PathSeparator)$env:PATH"

	if ($IsLinux)
	{
		function vcpkg { vcpkg.exe $args }
	}
}

# vim: ts=4 sw=4 sts=0 noexpandtab ff=dos ft=ps1 :
