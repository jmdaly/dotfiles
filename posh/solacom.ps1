# List of Solacom specific helper functions

function iqadmin-debug
{
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

function iqadmin
{
	Push-Location "c:\EdgeIQ\IQAdmin"

	Start-Process                                  `
		-FilePath javaw.exe                        `
		-ArgumentList "-Xmx512m",                  `
			"-classpath iqadmin.jar;dom4j-1.6.1.jar;mariadb-java-client-2.4.0.jar;axis.jar;commons-discovery-0.2.jar;javax.wsdl.jar;jaxrpc.jar;org.apache.commons.logging.jar;saaj.jar", `
			"com.versatelnetworks.admin.IQAdmin",  `
			"-probe", "-gateway", "-gatewaysr"

	Pop-Location
}

# vim: ts=4 sw=4 sts=0 noexpandtab ffs=dos ft=ps1 :
