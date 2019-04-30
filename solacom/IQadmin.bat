SETLOCAL

cd C:\EdgeIQ\IQadmin
set PATH=C:\Program Files (x86)\Java\jre1.8.0_131\bin
REM set PATH=C:\Program Files\Java\jdk1.8.0_211\bin

REM DB=mariadb-java-client-2.4.0.jar
set DB=mysql-connector-java-3.0.15-ga-bin.jar

REM Release
start javaw.exe -Xmx512m ^
   -classpath iqadmin.jar;dom4j-1.6.1.jar;%DB%;axis.jar;commons-discovery-0.2.jar;javax.wsdl.jar;jaxrpc.jar;org.apache.commons.logging.jar;saaj.jar  com.versatelnetworks.admin.IQAdmin ^
   -probe  -gateway  -gatewaysr

REM Debug
REM start java.exe -Xmx512m ^
REM    -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=0.0.0.0:5431 ^
REM    -classpath iqadmin.jar;dom4j-1.6.1.jar;%DB%;axis.jar;commons-discovery-0.2.jar;javax.wsdl.jar;jaxrpc.jar;org.apache.commons.logging.jar;saaj.jar;activation.jar;javax.mail.jar ^
REM    com.versatelnetworks.admin.IQAdmin -probe ^
REM    -gateway -gatewaysr ^
REM    -debug

ENDLOCAL