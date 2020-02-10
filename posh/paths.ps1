# Add some directories to our path.
Write-Host "Adjusting path" -ForegroundColor Yellow

if (!(Get-Variable java_jdk -Scope Global -ErrorAction SilentlyContinue))
{
	$java_jdk = "C:/Progra~1/Java/jdk1.8.0_211"

	# VS Code's JDK
	# $java_jdk="C:/java-1.8.0-openjdk-1.8.0.201-2.b09.redhat.windows.x86_64"
}

if ($IsWindows) { $ = ";" } else { $path_sep = ":" }

$custom_paths = @(
	("nmap.exe",       "C:/Progra~2/Nmap"),
	("notepad++.exe",  "C:/Progra~1/Notepa~1"),
	("mysql.exe",      "C:/Progra~1/MariaD~1.4/bin"),
	("Code.exe",       "C:/Progra~1/MIFA7F~1"),
	("java.exe",       "$java_jdk/bin"),
	("javax.mail.jar", "C:/jaf-1_1_1/jaf-1.1.1")
)
$custom_paths | ForEach-Object {
	$p = $_[1];
	if ($IsLinux) { $p = $(wslpath "$p") }
	if ((Test-Path $p) -And ((Get-Command $_[0] -ErrorAction SilentlyContinue) -eq $null)) {
		$env:PATH = "$p${path_sep}$env:PATH"
	}
}

$custom_paths = @(
	"$env:homepath\utils\win",
)
$custom_paths | ForEach-Object {
	$p = $_;
	if ($IsLinux) { $p = $(wslpath "$p") }

	if (Test-Path $p) {
		$env:PATH = "$p${path_sep}$env:PATH"
	}
}

# vim: ts=4 sw=4 sts=0 noexpandtab ff=dos ft=ps1 :
