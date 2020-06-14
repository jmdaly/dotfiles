if ($IsWindows -Or $IsWindows -eq $null)
{
	# VC Vars https://stackoverflow.com/a/2124759/1861346
	#
	# Review how MS Terminal does it with Set-MsBuildDevEnvironment at
	# https://github.com/microsoft/terminal tools/OpenConsole.psm1
	$vspath = "C:\\Program Files (x86)\\Microsoft Visual Studio\\2019\\Community\\Common7\\Tools"
	if (Test-Path $vspath)
	{
		pushd $vspath
		cmd.exe /c "VsDevCmd.bat&set" |
		foreach {
		  if ($_ -match "=") {
			$v = $_.split("="); set-item -force -path "ENV:\$($v[0])"  -value "$($v[1])"
		  }
		}
		popd
		Write-Host "`nVisual Studio 2019 Command Prompt variables set." -ForegroundColor Yellow
	}
	else
	{
		Write-Host "Cannot find Visual Studio, skipping setup"
	}
}
else
{
	# Once I started using the proper (Windows) msbuild executable (forced it
	# with an alias below - otherwise it'll use /use/bin/msbuild) stuff just
	# worked, so it's possible that I don't need to set $env:VCTargetPath If I
	# do though, I think it's at (note the two examples have slightly different
	# paths)
	# /c/Program Files (x86)/Microsoft Visual Studio/2019/BuildTools/Common7/IDE/VC/VCTargets/Microsoft.Cpp.Default.props
	# e.g.  $env:VCTargetPath="$(wslpath "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\IDE\VC\VCTargets\")"

	function msbuild {
		Write-Host "Overwriting msbuild"
		&"$(wslpath "C:/Program Files (x86)/Microsoft Visual Studio/2019/Community/MSBuild/15.0/Bin/MsBuild.exe")" $args
	}
}

function cmake
{
	$p=Join-Path "C:\Program Files\CMake\bin" "cmake.exe"
	Write-Host "Overwriting cmake"
	if ($IsLinux)
	{
		&"$(wslpath $p)" $args
	}
	else
	{
		&"$p" $args
	}
}

# # https://blog.lextudio.com/locate-msbuild-via-powershell-on-different-operating-systems-140757bb8e18
# $msBuild = "msbuild"
# try
# {
# 	& $msBuild /version
# 	Write-Host "Likely on Linux/macOS."
# }
# catch
# {
# 	Write-Host "MSBuild doesn't exist. Use VSSetup instead."
# 	Install-Module VSSetup -Scope CurrentUser -Force
# 	$instance = Get-VSSetupInstance -All -Prerelease | Select-VSSetupInstance -Require 'Microsoft.Component.MSBuild' -Latest
# 	$installDir = $instance.installationPath
# 	Write-Host "Visual Studio is found at $installDir"
# 	$msBuild = $installDir + '\MSBuild\Current\Bin\MSBuild.exe' # VS2019
# 	if (![System.IO.File]::Exists($msBuild))
# 	{
# 		$msBuild = $installDir + '\MSBuild\15.0\Bin\MSBuild.exe' # VS2019
# 		if (![System.IO.File]::Exists($msBuild))
# 		{
# 			Write-Host "MSBuild doesn't exist. Exit."
# 			exit 1
# 		}
# 	}
# 	Write-Host "Likely on Windows."
# }
# Write-Host "MSBuild found. Compile the projects."


# Because I only use PS right now to help with Windows stuff (I
# don't build linux apps with it, not yet at least), always target
# Windows' vcpkg
$env:VCPKG_ROOT=Join-Path ${env:WINHOME} vcpkg
if (Test-Path $env:VCPKG_ROOT)
{
	Write-Host "Loading vcpkg Powershell Integration." -ForegroundColor Yellow

	Import-Module $(Join-Path $(Join-Path $env:VCPKG_ROOT scripts) posh-vcpkg)
	$env:PATH = "$env:VCPKG_ROOT$([IO.Path]::PathSeparator)$env:PATH"

	if ($IsLinux)
	{
		function vcpkg { vcpkg.exe $args }
	}
}

# vim: ts=4 sw=4 sts=0 noexpandtab ff=dos ft=ps1 :
