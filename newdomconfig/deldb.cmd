rem delete the database
"C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\110\Tools\Binn\sqlcmd.exe" -S %Computername%\BES -U sa -P P2ssw0rd -i .\dropdb.sql

copy "C:\Program Files\Microsoft SQL Server\MSSQL12.BES\MSSQL\DATA\bes.mdf" "C:\Program Files\Microsoft SQL Server\MSSQL12.BES\MSSQL\DATA\old_bes.mdf"
copy "C:\Program Files\Microsoft SQL Server\MSSQL12.BES\MSSQL\DATA\bes.log" "C:\Program Files\Microsoft SQL Server\MSSQL12.BES\MSSQL\DATA\old_bes.log"
del "C:\Program Files\Microsoft SQL Server\MSSQL12.BES\MSSQL\DATA\bes*.*" 


rem delete the BES installation directory
rd "c:\program files\blackberry" /s /Q