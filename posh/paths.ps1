# Add some directories to our path.
Write-Host "Adjusting path" -ForegroundColor Yellow

$custom_paths = @(
	("nuget.exe",      "C:/Progra~2/Nuget"),
	("nmap.exe",       "C:/Progra~2/Nmap"),
	("cmake.exe",      "C:/Progra~1/CMake\bin"),
	("cmake.exe",      "C:/Progra~2/CMake\bin"),
	("notepad++.exe",  "C:/Progra~1/Notepa~1"),
	("Code.exe",       "C:/Progra~1/MIFA7F~1")
)
$custom_paths | ForEach-Object {
	$p = $_[1];
	if ($IsLinux) { $p = $(wslpath "$p") }
	# This is really slow...  Also in some cases might not be what I want
	# (wouldn't I want to overload these even if they do exist?  I know the
	# intent was to avoid duplicates..)
	# if ((Test-Path $p) -And ((Get-Command $_[0] -ErrorAction SilentlyContinue) -eq $null)) {
	if (Test-Path $p) {
		$env:PATH = "$p$([IO.Path]::PathSeparator)$env:PATH"
	}
}

Write-Host "   custom paths" -ForegroundColor Green
$custom_paths = @(
	"$env:homepath\utils\win"
)
$custom_paths | ForEach-Object {
	$p = $_;
	if ($IsLinux) { $p = $(wslpath "$p") }

	if (Test-Path $p) {
		$env:PATH = "$p$([IO.Path]::PathSeparator)$env:PATH"
	}
}

# vim: ts=4 sw=4 sts=0 noexpandtab ff=dos ft=ps1 :
