echo USE [master] >createadmin3.sql
echo GO >>createadmin3.sql
echo CREATE LOGIN [%userdomain%\%username%] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]>>createadmin3.sql
echo GO >>createadmin3.sql
echo ALTER SERVER ROLE [sysadmin] ADD MEMBER [%netbiosname%\bes12service]>>createadmin3.sql
echo GO>>createadmin3.sql
"C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\110\Tools\Binn\sqlcmd.exe" -S %Computername%\BES -U sa -P P2ssw0rd -i .\createadmin3.sql
echo Done setting SQL Permissions ...

