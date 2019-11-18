# VC Vars https://stackoverflow.com/a/2124759/1861346
#
# Review how MS Terminal does it with Set-MsBuildDevEnvironment at
# https://github.com/microsoft/terminal tools/OpenConsole.psm1
pushd "C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\bin"
cmd /c "VsDevCmd.bat&set" |
foreach {
  if ($_ -match "=") {
    $v = $_.split("="); set-item -force -path "ENV:\$($v[0])"  -value "$($v[1])"
  }
}
popd
Write-Host "`nVisual Studio 2010 Command Prompt variables set." -ForegroundColor Yellow

# Example of build command
# MSBuild.exe /m:6 /p:warn=0 /p:nowarn=0436 /p:Configuration=Debug .\Liberty.sln /target:'CpeServer;InstallServer'

# vim: ts=4 sw=4 sts=0 noexpandtab ffs=unix ft=ps1 :
