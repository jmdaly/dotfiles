# Add some directories to our path.
Write-Host "Adjusting path" -ForegroundColor Yellow

if (!(Get-Variable java_jdk -Scope Global -ErrorAction SilentlyContinue))
{
	$java_jdk = "C:/Progra~1/Java/jdk1.8.0_211"

	# VS Code's JDK
	# $java_jdk="C:/java-1.8.0-openjdk-1.8.0.201-2.b09.redhat.windows.x86_64"
}

$custom_paths = @(
	("nmap.exe",       "C:/Progra~2/Nmap"),
	("notepad++.exe",  "C:/Progra~1/Notepa~1"),
	("mysql.exe",      "C:/Progra~1/MariaD~1.3/bin"),
	("Code.exe",       "C:/Progra~1/MIFA7F~1"),
	("java.exe",       $java_jdk + "/bin"),
	("javax.mail.jar", "C:/jaf-1_1_1/jaf-1.1.1")
)
$custom_paths | ForEach-Object {
	if ((Test-Path $_[1]) -And ((Get-Command $_[0] -ErrorAction SilentlyContinue) -eq $null)) {
		$env:path = $_[1] + ";$env:path"
	}
}

# vim: ts=4 sw=4 sts=0 noexpandtab ffs=dos ft=ps1 :
