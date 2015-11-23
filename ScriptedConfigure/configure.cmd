@echo off
rem wait 5 seconds...
ping 127.0.0.1 -n 4 > nul

cd c:\blackberry\scr



start setupmonitor.exe

ping 127.0.0.1 -n 10 > nul

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

rem Create local admin service account
net user /add bes12service P2ssw0rd /expires:never /logonpasswordchg:no /comment:"BES service account"
WMIC USERACCOUNT WHERE "Name='bes12service'" SET PasswordExpires=FALSE
net localgroup administrators bes12service /add

rem configure rights
ntrights +r SeServiceLogonRight -u "bes12service" 

rem Add bes12service account to SQL Server
echo USE [master] >createadmin2.sql
echo GO >>createadmin2.sql
echo CREATE LOGIN [%computername%\bes12service] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]>>createadmin2.sql
echo GO >>createadmin2.sql
echo ALTER SERVER ROLE [sysadmin] ADD MEMBER [%computername%\bes12service]>>createadmin2.sql
echo GO>>createadmin2.sql
"C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\110\Tools\Binn\sqlcmd.exe" -S %Computername%\BES -U sa -P P2ssw0rd -i .\createadmin2.sql
echo Done setting SQL Permissions ...
echo ...

rem Configure Services
sc config "BESNG-Core" obj=%computername%\bes12service password=P2ssw0rd
sc config "BES12 - BlackBerry Affinity Manager" obj=%computername%\bes12service password=P2ssw0rd
sc config "BES12 - BlackBerry Dispatcher" obj=%computername%\bes12service password=P2ssw0rd
sc config "BES - BlackBerry Gatekeeping Service" obj=%computername%\bes12service password=P2ssw0rd
sc config "BES12 - BlackBerry MDS Connection Service" obj=%computername%\bes12service password=P2ssw0rd
sc config "BESNG-P2E" obj=%computername%\bes12service password=P2ssw0rd
sc config "BES - BlackBerry Work Connection Notification Service" obj=%computername%\bes12service password=P2ssw0rd
sc config "BESNG-UI" obj=%computername%\bes12service password=P2ssw0rd

rem Update DB.Properties file
echo configuration.database.ng.server=%computername%>>dbprops1.txt
copy dbprops1.txt + dbprops2.txt DB.properties
copy DB.properties "C:\Program Files\BlackBerry\BES\common-settings" /Y

rem clean up scheduled task
rem SchTasks /Delete /TN "Configure BES" /F

rem add scheduled task
schtasks /Create /XML "BES First Run.xml" /TN "BES First Run"

rem Copy shortcuts


rem Restart
echo done>c:\blackberry\setupdone.txt
cd\blackberry
rd scr /s /q



