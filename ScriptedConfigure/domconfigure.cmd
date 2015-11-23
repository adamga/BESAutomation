@echo off

cd c:\blackberry\scr

rem get the environment variables from the wizard
rem call envvars.cmd



rem Turn of IEC
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}" /v "IsInstalled" /t REG_DWORD /d 0 /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}" /v "IsInstalled" /t REG_DWORD /d 0 /f
Rundll32 iesetup.dll, IEHardenLMSettings
Rundll32 iesetup.dll, IEHardenUser
Rundll32 iesetup.dll, IEHardenAdmin
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}" /f /va
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}" /f /va
:: Optional to remove warning on first IE Run and set home page to blank.
REG DELETE "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main" /v "First Home Page" /f
REG ADD "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main" /v "Default_Page_URL" /t REG_SZ /d "about:blank" /f
REG ADD "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main" /v "Start Page" /t REG_SZ /d "about:blank" /f
REG ADD "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main" /v "DisableFirstRunCustomize" /t REG_DWORD /d 1 /f

rem Create admin service account
net user /add bes12service P2ssw0rd /expires:never /logonpasswordchg:no /comment:"BES service account" /domain
WMIC USERACCOUNT WHERE "Name='bes12service'" SET PasswordExpires=FALSE
net localgroup administrators %userdomain%\bes12service /add

rem remove bes services
sc delete "BESNG-Core" 
sc delete "BES12 - BlackBerry Affinity Manager" 
sc delete "BES12 - BlackBerry Dispatcher" 
sc delete "BES - BlackBerry Gatekeeping Service" 
sc delete "BES12 - BlackBerry MDS Connection Service" 
sc delete "BESNG-P2E" 
sc delete "BES - BlackBerry Work Connection Notification Service" 
sc delete "BESNG-UI" 

rem delete bes installation
rd "c:\program files\blackberry" /s /Q



rem configure rights
ntrights +r SeServiceLogonRight -u "%userdomain%\bes12service" 

rem Add bes12service account to SQL Server
echo USE [master] >createadmin2.sql
echo GO >>createadmin2.sql
echo CREATE LOGIN [%userdomain%\bes12service] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]>>createadmin2.sql
echo GO >>createadmin2.sql
echo ALTER SERVER ROLE [sysadmin] ADD MEMBER [%userdomain%\bes12service]>>createadmin2.sql
echo GO>>createadmin2.sql
"C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\110\Tools\Binn\sqlcmd.exe" -S %Computername%\BES -U sa -P P2ssw0rd -i .\createadmin2.sql
echo Done setting SQL Permissions ...
echo ...

rem add current user to sql server
echo USE [master] >createadmin3.sql
echo GO >>createadmin3.sql
echo CREATE LOGIN [%userdomain%\%username%] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]>>createadmin3.sql
echo GO >>createadmin3.sql
echo ALTER SERVER ROLE [sysadmin] ADD MEMBER [%userdomain%\%username%]>>createadmin3.sql
echo GO>>createadmin3.sql
"C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\110\Tools\Binn\sqlcmd.exe" -S %Computername%\BES -U sa -P P2ssw0rd -i .\createadmin3.sql
echo Done setting SQL Permissions ...

rem install bes
cd\blackberry
del machine.properties
start "Installing BES..." /b /high /wait Setup.exe --script --iAcceptBESEULA
cd c:\blackberry\scr

rem Configure Services to use new service account
sc config "BESNG-Core" obj=%userdomain%\bes12service password=P2ssw0rd
sc config "BES12 - BlackBerry Affinity Manager" obj=%userdomain%\bes12service password=P2ssw0rd
sc config "BES12 - BlackBerry Dispatcher" obj=%userdomain%\bes12service password=P2ssw0rd
sc config "BES - BlackBerry Gatekeeping Service" obj=%userdomain%\bes12service password=P2ssw0rd
sc config "BES12 - BlackBerry MDS Connection Service" obj=%userdomain%\bes12service password=P2ssw0rd
sc config "BESNG-P2E" obj=%userdomain%\bes12service password=P2ssw0rd
sc config "BES - BlackBerry Work Connection Notification Service" obj=%userdomain%\bes12service password=P2ssw0rd
sc config "BESNG-UI" obj=%userdomain%\bes12service password=P2ssw0rd


rem clean up scheduled task
SchTasks /Delete /TN "Configure BES" /F

rem add scheduled task
schtasks /Create /XML "BES First Run.xml" /TN "BES First Run"

rem Restart
cd\blackberry
echo done>c:\blackberry\setupdone.txt
rd scr /s /q






