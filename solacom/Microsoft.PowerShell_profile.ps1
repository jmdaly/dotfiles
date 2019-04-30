# Helper function to set location to the User Profile directory
function cuserprofile { Set-Location ~ }
Set-Alias ~ cuserprofile -Option AllScope

# https://github.com/joonro/Get-ChildItemColor
# verify this is the console and not the ISE
Import-Module Get-ChildItemColor
Set-Alias ls Get-ChildItemColor -option AllScope

function iqadmin
{
	Push-Location "c:\EdgeIQ\IQAdmin"

	$db="mysql-connector-java-3.0.15-ga-bin.jar"
	# $db="mariadb-java-client-2.4.0.jar"

	Start-Process                                  `
		-FilePath javaw.exe                        `
		-ArgumentList "-Xmx512m",                  `
			"-classpath iqadmin.jar;dom4j-1.6.1.jar;$db;axis.jar;commons-discovery-0.2.jar;javax.wsdl.jar;jaxrpc.jar;org.apache.commons.logging.jar;saaj.jar", `
			"com.versatelnetworks.admin.IQAdmin",  `
			"-probe", "-gateway", "-gatewaysr"

	Pop-Location
}