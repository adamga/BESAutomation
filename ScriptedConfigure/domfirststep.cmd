@echo off

rem remove scheduled task
rem SchTasks /Delete /TN "Firstboot" /F

rem add scheduled task
schtasks /Create /XML "ConfigureBESDOM.xml" /TN "Configure BES"

rem start the setup monitor
start setupmonitordom.exe 


rem disable bes services from starting to enable cleanup at next boot
sc config "BESNG-Core" start=disabled
sc config "BES12 - BlackBerry Affinity Manager" start=disabled
sc config "BES12 - BlackBerry Dispatcher" start=disabled
sc config "BES - BlackBerry Gatekeeping Service" start=disabled
sc config "BES12 - BlackBerry MDS Connection Service" start=disabled
sc config "BESNG-P2E" start=disabled
sc config "BES - BlackBerry Work Connection Notification Service" start=disabled
sc config "BESNG-UI" start=disabled

rem drop bes database
"C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\110\Tools\Binn\sqlcmd.exe" -S %Computername%\BES -U sa -P P2ssw0rd -i .\dropdb.sql

rem run the dcpromo task
call dompromo.cmd

