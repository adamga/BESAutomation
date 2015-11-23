rem disable services pre-reboot

sc config "BESNG-Core" start=disabled
sc config "BES12 - BlackBerry Affinity Manager" start=disabled
sc config "BES12 - BlackBerry Dispatcher" start=disabled
sc config "BES - BlackBerry Gatekeeping Service" start=disabled
sc config "BES12 - BlackBerry MDS Connection Service" start=disabled
sc config "BESNG-P2E" start=disabled
sc config "BES - BlackBerry Work Connection Notification Service" start=disabled
sc config "BESNG-UI" start=disabled

rem create the domain

rem delete the services
sc delete "BESNG-Core" 
sc delete "BES12 - BlackBerry Affinity Manager" 
sc delete "BES12 - BlackBerry Dispatcher" 
sc delete "BES - BlackBerry Gatekeeping Service" 
sc delete "BES12 - BlackBerry MDS Connection Service" 
sc delete "BESNG-P2E" 
sc delete "BES - BlackBerry Work Connection Notification Service" 
sc delete "BESNG-UI"  

rem delete the database
"C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\110\Tools\Binn\sqlcmd.exe" -S %Computername%\BES -U sa -P P2ssw0rd -i .\dropdb.sql

copy "C:\Program Files\Microsoft SQL Server\MSSQL12.BES\MSSQL\DATA\bes.mdf" "C:\Program Files\Microsoft SQL Server\MSSQL12.BES\MSSQL\DATA\old_bes.mdf"
copy "C:\Program Files\Microsoft SQL Server\MSSQL12.BES\MSSQL\DATA\bes.log" "C:\Program Files\Microsoft SQL Server\MSSQL12.BES\MSSQL\DATA\old_bes.log"
del "C:\Program Files\Microsoft SQL Server\MSSQL12.BES\MSSQL\DATA\bes*.*" 


rem delete the BES installation directory
rd "c:\program files\blackberry" /s /Q


run BES setup against existing SQL instance
cd c:\blackberry
setup.exe --script --iAcceptBESEULA --properties "db.authentication.type=USER;db.user=sa,db.pass=P2ssw0rd;service.account.name=%userdomain%\bes12service,service.account.password=P2ssw0rd"